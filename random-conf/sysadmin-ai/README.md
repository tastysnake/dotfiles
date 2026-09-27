# SysAdmin AI companion workspace

This project equips your AI companion with dedicated Model Context Protocol (MCP) servers designed to assist with system administration, remote shell management, file uploads, and text classification tasks.

It requires that you previously install VSCode with Zoo Code extension, and configure this directory as its workspace.

## 🛠️ Integrated MCP Servers

This workspace utilizes two primary MCP servers:

1. **SSH-Connect**
   - **Source:** [SSH-Connect Repository](https://github.com/mixelpixx/SSH-Connect)
   - **Purpose:** Handles SSH connectivity, command execution, and remote file uploads to target servers.

2. **Text Classifier**
   - **Source:** In-house Python development (`mcp-servers/text-classifier`)
   - **Purpose:** Custom Python-based text classification tool powered by OpenRouter and `jev-latest` for fast and cheap decision making.

## 📁 Directory structure

```text
.
├── .gitignore
├── .roo/
│   └── mcp.json
├── .roomodes
└── mcp-servers/
    ├── ssh-connect/
    └── text-classifier/
        ├── config.sample.yml
        ├── requirements.txt
        └── text-classifier.py
```

## 🚀 Onboarding

Follow these steps to get your workspace set up and ready to use:

### 1. Set up ssh-connect

1. Download the latest release binary or source from [SSH-Connect](https://github.com/mixelpixx/SSH-Connect).
2. Extract or place the binary directly as `mcp-servers/ssh-connect`.

### 2. Set up text classifier

1. Navigate to the text classifier directory:

   ```bash
   cd mcp-servers/text-classifier
   ```

2. Create a virtual environment (`venv`):

   ```bash
   python -m venv venv
   ```

3. Activate the virtual environment:

     ```bash
     source venv/bin/activate
     ```

4. Install the required dependencies:

   ```bash
   pip install -r requirements.txt
   ```

### 3. Configure API credentials

1. In `mcp-servers/text-classifier/`, copy `config.sample.yml` to create your active configuration file:

   ```bash
   cp config.sample.yml config.yml
   ```

2. Open `config.yml` and ensure your **OpenRouter API token** is present and properly configured.

## ⚙️  Configuration notes

- The MCP setup is defined in `.roo/mcp.json`. Ensure paths inside this file point correctly to your virtual environment Python binary and the `ssh-connect` executable.
- Custom modes or prompt behaviors for the AI assistant are managed via `.roomodes`.
