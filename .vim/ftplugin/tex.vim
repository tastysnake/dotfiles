" auto-cut some lines.
" (only modify locally, i.e. only that file)
"
setlocal textwidth=78

" Leader for .tex files
" (also affects vimtex mappings)
let maplocalleader = ";"


" comment with %%
"
" the <buffer> option makes it work only for the
" current buffer, because otherwise opening just
" one .tex file, and then switching to another,
" different filetype, is annoying because it
" propagates all the settings.
"
inoremap <buffer> %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

" General replace thingy
"
" This will replace automatically any <++> placeholder whenever
" I type <localleader> twice. then, I just add the <++> to any auto-insert
" command to add a specific chunk of code and then continue normally
" when I type <localleader>.

inoremap <buffer> <localleader><localleader> <Esc>/<++><CR>4s

" new paragraph, chapter, section, subsection, subsubsection, part
" and their starred equivalents

inoremap <buffer> <localleader>P <Esc>30i%<Esc>:t.<CR>:t.<CR>o<CR>\part{}<CR><CR><++><Esc>2k0f{a
inoremap <buffer> <localleader>.P <Esc>30i%<Esc>:t.<CR>:t.<CR>o<CR>\part*{}<CR><CR><++><Esc>2k0f{a
inoremap <buffer> <localleader>C <Esc>30i%<Esc>:t.<CR>:t.<CR>o<CR>\chapter{}<CR><CR><++><Esc>2k0f{a
inoremap <buffer> <localleader>.C <Esc>30i%<Esc>:t.<CR>:t.<CR>o<CR>\chapter*{}<CR><CR><++><Esc>2k0f{a
inoremap <buffer> <localleader>S <Esc>30i%<Esc>:t.<CR>o<CR>\section{}<CR><CR><++><Esc>2k0f{a
inoremap <buffer> <localleader>.S <Esc>30i%<Esc>:t.<CR>o<CR>\section*{}<CR><CR><++><Esc>2k0f{a
inoremap <buffer> <localleader>sS <Esc>30i%<Esc>o<CR>\subsection{}<CR><CR><++><Esc>2k0f{a
inoremap <buffer> <localleader>.sS <Esc>30i%<Esc>o<CR>\subsection*{}<CR><CR><++><Esc>2k0f{a
inoremap <buffer> <localleader>ssS <Esc>30i%<Esc>o<CR>\subsubsection{}<CR><CR><++><Esc>2k0f{a
inoremap <buffer> <localleader>.ssS <Esc>30i%<Esc>o<CR>\subsubsection*{}<CR><CR><++><Esc>2k0f{a
inoremap <buffer> <localleader>p <Esc>30i%<Esc>o<CR>\paragraph{}<CR><CR><++><Esc>2k0f{a
inoremap <buffer> <localleader>.p <Esc>30i%<Esc>o<CR>\paragraph*{}<CR><CR><++><Esc>2k0f{a
inoremap <buffer> <localleader>pp <Esc>30i%<Esc>o<CR>\subparagraph{}<CR><CR><++><Esc>2k0f{a
inoremap <buffer> <localleader>.pp <Esc>30i%<Esc>o<CR>\subparagraph*{}<CR><CR><++><Esc>2k0f{a

" Emphasis and bold
"
inoremap <buffer> <localleader>b \textbf{} <++><Esc>F{a
inoremap <buffer> <localleader>e \emph{} <++><Esc>F{a

" Replace quotes
" usage: first one, type normally. Second, double type it.
inoremap <buffer> "" "<Esc>?"<CR>s``<Esc>Ns''
inoremap <buffer> '' '<Esc>?'<CR>s`<Esc>Na

" Sub and superscript<localleader> chose - instead of ^ cause it was easier to hit
inoremap <buffer> <localleader>_ \textsubscript{}<++><Esc>?\\textsubscript{}<CR>f}i
inoremap <buffer> <localleader>- \textsuperscript{}<++><Esc>?\\textsuperscript{}<CR>f}i

" Some common environments
" -nmemonic would be <localleader>Eq[uation], ;Fi[gure], etc.
" Equations
inoremap <buffer> <localleader>Eq \begin{equation}<CR>%<CR><CR>%<CR>\end{equation}<CR><CR><++><Esc>3k<2kjA    
inoremap <buffer> <localleader>.Eq \begin{equation*}<CR>%<CR><CR>%<CR>\end{equation*}<CR><CR><++><Esc>3k<2kjA    
" Figures
inoremap <buffer> <localleader>Fi \begin{figure}[]<CR>\centering<CR>\includegraphics[<CR>    width=<++>\textwidth<CR>]{<++>}<CR>\caption{<++>}<CR>\label{<++>}<CR>\end{figure}<CR><CR><++><Esc><4k?{figure}[]<CR>$i
" Tables
inoremap <buffer> <localleader>Ta \begin{table}[]<CR>\centering<CR>\begin{tabular}{<++>}<CR><++><CR>\end{tabular}<CR>\caption{<++>}<CR>\label{<++>}<CR>\end{table}<CR><CR><++><Esc>?{table}[]<CR>$i
" Itemize
inoremap <buffer> <localleader>It \begin{itemize}<CR><CR><CR>\end{itemize}<CR><CR><++><Esc>3kA
" extra item
inoremap <buffer> <localleader>it \item <CR><++><Esc>kA
" Enumerate
inoremap <buffer> <localleader>En \begin{enumerate}<CR><CR><CR>\end{enumerate}<CR><CR><++><Esc>3kA
" Center
inoremap <buffer> <localleader>Ce \begin{center}<CR><CR><CR><CR>\end{center}<CR><CR><++><Esc>4kA

" Reference autocompletion (+ vimtex)
" Requires having been compiled once before the
" new labels are available<localleader> probably requires having run biber
" or shit.
" Packages needed: biblatex and csquotes for *cite* commands
" and hyperref for autoref command.
" Obviously, needs a valid bibliography file.
inoremap <buffer> <localleader>rr \ref{}<++><Esc>F{a<C-x><C-o>
inoremap <buffer> <localleader>rp \pageref{}<++><Esc>F{a<C-x><C-o>
inoremap <buffer> <localleader>re \eqref{}<++><Esc>F{a<C-x><C-o>
inoremap <buffer> <localleader>ra \autoref{}<++><Esc>F{a<C-x><C-o>
inoremap <buffer> <localleader>cc \cite{}<++><Esc>F{a<C-x><C-o>
inoremap <buffer> <localleader>ca \citeauthor{}<++><Esc>F{a<C-x><C-o>
inoremap <buffer> <localleader>cf \footcite{}<++><Esc>F{a<C-x><C-o>
inoremap <buffer> <localleader>ct \textcite{}<++><Esc>F{a<C-x><C-o>

" Greek letters
" g = greek (requires textgreek package)

inoremap <buffer> <localleader>ga \textalpha
inoremap <buffer> <localleader>gA \textAlpha
inoremap <buffer> <localleader>gb \textbeta
inoremap <buffer> <localleader>gc \textchi
inoremap <buffer> <localleader>gd \textdelta
inoremap <buffer> <localleader>gD \textDelta
inoremap <buffer> <localleader>ge \textepsilon
inoremap <buffer> <localleader>gE \textEpsilon
inoremap <buffer> <localleader>gf \straightphi
inoremap <buffer> <localleader>gF \textPhi
inoremap <buffer> <localleader>gg \textgamma
inoremap <buffer> <localleader>gG \textGamma
inoremap <buffer> <localleader>gk \textkappa
inoremap <buffer> <localleader>gl \textlambda
inoremap <buffer> <localleader>gL \textLambda
inoremap <buffer> <localleader>gm \textmugreek
inoremap <buffer> <localleader>gn \textnu
inoremap <buffer> <localleader>go \textomega
inoremap <buffer> <localleader>gO \textOmega
inoremap <buffer> <localleader>gp \textpi
inoremap <buffer> <localleader>gP \textPi
inoremap <buffer> <localleader>gr \textrho
inoremap <buffer> <localleader>gs \textsigma
inoremap <buffer> <localleader>gs \textsigma
inoremap <buffer> <localleader>gS \textSigma
inoremap <buffer> <localleader>gt \straighttheta
inoremap <buffer> <localleader>gT \textTheta
inoremap <buffer> <localleader>gw \textpsi
inoremap <buffer> <localleader>gW \textPsi
