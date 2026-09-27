import os
import sys
import json
import logging
from pathlib import Path
from typing import List, Dict, Any, Union, Annotated
import httpx
from pydantic import Field
from mcp.server import MCPServer
from mcp.types import TextContent

# Force all logging to stderr to prevent stream corruption on stdout
logging.basicConfig(level=logging.ERROR, stream=sys.stderr)
logging.getLogger("httpx").setLevel(logging.WARNING)
logging.getLogger("httpcore").setLevel(logging.WARNING)

# ==============================================================================
# CONFIGURATION & CONSTANTS
# ==============================================================================

DECISIONS_API_URL = "https://openrouter.ai/api/alpha/decisions"
CONFIG_PATH = Path(__file__).parent / "config.yml"


def get_config() -> Dict[str, str]:
    """Retrieves config from environment variables, falling back to local config.yml."""
    file_env: Dict[str, Any] = {}

    if CONFIG_PATH.is_file():
        try:
            import yaml  # Lazy import to avoid crash if pyyaml is missing when env vars are used

            with open(CONFIG_PATH, "r", encoding="utf-8") as f:
                data = yaml.safe_load(f) or {}
                file_env = data.get("env", {})
        except Exception as err:
            sys.stderr.write(f"Warning: Failed to parse {CONFIG_PATH}: {err}\n")

    api_key = os.environ.get("OPENROUTER_API_KEY") or file_env.get("OPENROUTER_API_KEY")
    model_name = os.environ.get("MODEL_NAME") or file_env.get("MODEL_NAME")

    missing = []
    if not api_key:
        missing.append("OPENROUTER_API_KEY")
    if not model_name:
        missing.append("MODEL_NAME")

    if missing:
        raise ValueError(
            f"Missing required configuration key(s): {', '.join(missing)}. "
            f"Provide them via environment variables or in {CONFIG_PATH.name}."
        )

    return {
        "api_key": str(api_key),
        "model_name": str(model_name),
    }


# ==============================================================================
# TOOL DESCRIPTIONS
# ==============================================================================

DESC_CHOOSE_OPTION = (
    "Evaluates candidates against context using Jev's Choice primitive. "
    "Selects the optimal option and returns probabilities for all candidates. "
    "Accepts candidates either as a flat list of strings OR a dictionary mapping "
    "option keys to detailed criteria descriptions (recommended for accuracy)."
)

DESC_SCORE_RUBRIC = (
    "Evaluates context against an ordered N-level rubric using Jev's Score primitive. "
    "Returns a discrete score selection along with continuous scale positioning. "
    "The rubric criteria MUST be provided as an ordered list of strings from lowest to highest."
)

DESC_ASSESS_HYPOTHESIS = (
    "Evaluates the likelihood (0.00 to 1.00) of a single hypothesis based on evidence "
    "using Jev's Noul (Yes/No) primitive. Returns a raw probability without generative text."
)

DESC_ANALYZE_STATE = (
    "Executes concurrent multi-primitive decisions (Choice, Score, Noul) in a single API round-trip. "
    "Requires a valid Jev questions payload dictionary. "
    "Criteria requirements per type: "
    "- 'choice': criteria MUST be a dict mapping option keys to descriptions (e.g. {'opt1': 'description'}). "
    "- 'noul': criteria MUST be a dict with EXACTLY the keys 'true' and 'false' (e.g. {'true': 'description', 'false': 'description'}). "
    "- 'score': criteria MUST be an ordered list of strings from lowest to highest level (e.g. ['Low', 'Medium', 'High'])."
)

# Initialize MCP Server
app = MCPServer("text-classifier")

# ==============================================================================
# DECISIONS API HELPER
# ==============================================================================


async def query_decisions_api(state: str, questions: Dict[str, Any]) -> Dict[str, Any]:
    config = get_config()

    headers = {
        "Authorization": f"Bearer {config['api_key']}",
        "Content-Type": "application/json",
        "HTTP-Referer": "http://mcp-text-classifier",
        "X-OpenRouter-Title": "Text Classifier MCP",
    }

    payload = {
        "model": config["model_name"],
        "state": state,
        "questions": questions,
    }

    async with httpx.AsyncClient(timeout=10.0) as client:
        response = await client.post(DECISIONS_API_URL, headers=headers, json=payload)

        if response.status_code != 200:
            sys.stderr.write(f"\n[HTTP ERROR {response.status_code}] Body: {response.text}\n")
            response.raise_for_status()

        data = response.json()
        return data.get("answers", {})


# ==============================================================================
# MCP TOOL DEFINITIONS
# ==============================================================================


@app.tool(name="choose_option", description=DESC_CHOOSE_OPTION)
async def choose_option(
    context: Annotated[
        str,
        Field(description="The full text, state, or context string to be evaluated by the classifier."),
    ],
    candidates: Annotated[
        Union[Dict[str, str], List[str]],
        Field(
            description=(
                "Candidate options to evaluate. Either a list of option strings (e.g. ['optA', 'optB']) "
                "OR a dictionary mapping key names to criteria descriptions (e.g. {'optA': 'Description of optA'})."
            )
        ),
    ],
    instruction: Annotated[
        str,
        Field(description="Directive guiding how candidates should be evaluated against the context."),
    ] = "Select the optimal choice based on context.",
) -> Union[str, Dict[str, Any]]:
    try:
        if isinstance(candidates, list):
            criteria_map = {opt: opt for opt in candidates}
        else:
            criteria_map = candidates

        questions = {
            "selection": {
                "type": "choice",
                "instructions": instruction,
                "criteria": criteria_map,
            }
        }
        answers = await query_decisions_api(state=context, questions=questions)
        return json.dumps(answers.get("selection", {}))
    except ValueError as err:
        return {
            "content": [TextContent(type="text", text=f"Configuration Error: {str(err)}")],
            "isError": True,
        }
    except Exception as err:
        return {
            "content": [TextContent(type="text", text=f"API Execution Error: {str(err)}")],
            "isError": True,
        }


@app.tool(name="score_rubric", description=DESC_SCORE_RUBRIC)
async def score_rubric(
    context: Annotated[
        str,
        Field(description="The text or situation state to evaluate against the ordered rubric."),
    ],
    rubric: Annotated[
        List[str],
        Field(
            description=(
                "An ordered list of string labels representing progressive levels from lowest to highest "
                "(e.g. ['Low', 'Medium', 'High']). Must contain at least 2 levels."
            )
        ),
    ],
    instruction: Annotated[
        str,
        Field(description="Directive specifying what dimension is being scored across the rubric levels."),
    ] = "Rate the severity or level based on context.",
) -> Union[str, Dict[str, Any]]:
    try:
        questions = {
            "score_eval": {
                "type": "score",
                "instructions": instruction,
                "criteria": rubric,
            }
        }
        answers = await query_decisions_api(state=context, questions=questions)
        return json.dumps(answers.get("score_eval", {}))
    except ValueError as err:
        return {
            "content": [TextContent(type="text", text=f"Configuration Error: {str(err)}")],
            "isError": True,
        }
    except Exception as err:
        return {
            "content": [TextContent(type="text", text=f"API Execution Error: {str(err)}")],
            "isError": True,
        }


@app.tool(name="assess_hypothesis", description=DESC_ASSESS_HYPOTHESIS)
async def assess_hypothesis(
    hypothesis: Annotated[
        str,
        Field(description="The specific statement or claim to evaluate as true or false."),
    ],
    evidence: Annotated[
        str,
        Field(description="The contextual evidence or facts provided to evaluate the hypothesis against."),
    ],
) -> Union[str, Dict[str, Any]]:
    try:
        questions = {
            "hypothesis_check": {
                "type": "noul",
                "instructions": f"Is this hypothesis true: {hypothesis}?",
                "criteria": {
                    "true": "Supported by the provided evidence",
                    "false": "Contradicted or unsupported by evidence",
                },
            }
        }
        answers = await query_decisions_api(state=evidence, questions=questions)
        return json.dumps(answers.get("hypothesis_check", {}))
    except ValueError as err:
        return {
            "content": [TextContent(type="text", text=f"Configuration Error: {str(err)}")],
            "isError": True,
        }
    except Exception as err:
        return {
            "content": [TextContent(type="text", text=f"API Execution Error: {str(err)}")],
            "isError": True,
        }


@app.tool(name="analyze_state", description=DESC_ANALYZE_STATE)
async def analyze_state(
    state: Annotated[
        str,
        Field(description="The base text or context string shared across all concurrent questions."),
    ],
    questions: Annotated[
        Dict[str, Any],
        Field(description="A dictionary mapping decision IDs to Jev question structures."),
    ],
) -> Union[str, Dict[str, Any]]:
    try:
        answers = await query_decisions_api(state=state, questions=questions)
        return json.dumps(answers)
    except ValueError as err:
        return {
            "content": [TextContent(type="text", text=f"Configuration Error: {str(err)}")],
            "isError": True,
        }
    except Exception as err:
        return {
            "content": [TextContent(type="text", text=f"API Execution Error: {str(err)}")],
            "isError": True,
        }


if __name__ == "__main__":
    app.run(transport="stdio")
