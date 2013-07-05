cp basics.tex index.tex
#sed -i 's/\\vspace{[^}]*}//' index.tex
sed -i -e 's/\\begin{lstlisting}\[language=sh\]/\\begin{verbatim}/' -e 's/\end{lstlisting}%%%/\end{verbatim}/' index.tex
htlatex index.tex && echo -e "\n\n\n"

	sed -i 's/<\/h3>/<hr><\/h3>/g' index.html
	sed -i 's/\&#x00A0;<span class=\"subsectionToc/\&#x00A0;\&#x00A0;\&#x00A0;\&#x00A0;\&#x00A0;\&#x00A0;<span class=\"subsectionToc/' index.html
	sed -i 's/\&#x00A0;<span class=\"subsubsectionToc/\&#x00A0;\&#x00A0;\&#x00A0;\&#x00A0;\&#x00A0;\&#x00A0;\&#x00A0;\&#x00A0;\&#x00A0;\&#x00A0;\&#x00A0;\&#x00A0;<span class=\"subsectionToc/' index.html

sed -i '/<p class=\"noindent\" ><hr class=\"float\"><div class=\"float\"/{n;d;}' index.html
sed -i '/<p class=\"noindent\" ><hr class=\"float\"><div class=\"float\"/d' index.html	
sed -i 's/<\/div><hr class=\"endfloat\" \/>//' index.html

firefox index.html &
