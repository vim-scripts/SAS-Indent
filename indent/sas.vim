" Vim indent file
" Language:	    SAS
" Maintainer:       Zhenhuan Hu <zhu@mcw.edu>
" Latest Revision:  2012-04-26

if exists("b:did_indent")
	finish
endif
let b:did_indent = 1

setlocal indentexpr=GetSASIndent() indentkeys+==data,=proc,=run;,=end;,=endsas,=select,=%macro,=%mend

if exists("*GetSASIndent")
	finish
endif

let s:cpo_save = &cpo
set cpo&vim

" ----------------------------------
" Main Function
" ----------------------------------
function GetSASIndent()

	let lnum = prevnonblank(v:lnum - 1)
	let ind = indent(lnum)
	let pline = getline(lnum)
	let cline = getline(v:lnum)

	" ----------------------------------
	" Location	 - 1st Line
	" Action	 - Set to column 0
	" ----------------------------------

	if lnum == 0
		return 0
	endif

	" ----------------------------------
	" Location	 - Previous Line
	" Action	 - Add a soft tab stop
	" Matched Words	 - DATA, PROC, DO, SELECT, %MACRO
	" ----------------------------------

	if pline =~ '^\s*data\>'
	\ || pline =~ '^\s*proc\>'
	\ || pline =~ '\<do\>.*\<to\>'
	\ || pline =~ '\<do;'
	\ || pline =~ '\<select ('
	\ || pline =~ '\<select;'
	\ || pline =~ '%macro\>'
		let ind = ind + &sts
	endif

	" ----------------------------------
	" Location	 - Current Line
	" Action	 - Return to column 0
	" Matched Words  - ENDSAS, %MEND
	" ----------------------------------

	if cline =~ '\<endsas\>'
	\ || cline =~ '%mend\>'
		return 0
	endif

	" ----------------------------------
	" Location	 - Current line
	" Action	 - Substract a soft tab stop
	" Matched Words  - END, RUN
	" ----------------------------------

	if cline =~ '\<end;'
	\ || cline =~ '\<run;'
		return ind - &sts
	endif

	" ----------------------------------
	" Location	 - Current line
	" Matched Words  - PROC
	" Location	 - Previous Line
	" Does Not Match - RUN, ENDSAS, %MEND
	" Action	 - Substract a soft tab stop
	" ----------------------------------

	if cline =~ '^\s*proc\>'
	\ && pline !~ '\(\<run;\|\<endsas\>\|%mend\>\)'
		return ind - &sts
	endif

	return ind
endfunction

let &cpo = s:cpo_save
unlet s:cpo_save
