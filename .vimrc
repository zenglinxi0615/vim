set nu
""""""""""""""""""""""""""""""
" Tag list (ctags)
""""""""""""""""""""""""""""""

"进行版权声明的设置
"添加或更新头
"function AddTitle()
"    call append(0,"/*=============================================================================")
"    call append(1,"*")
"    call append(2,"* Author:ydx - mryuan0@gmail.com")
"    call append(3,"*")
"    call append(4,"* QQ:1179923349")
"    call append(5,"*")
"    call append(6,"* Last modified:".strftime("%Y-%m-%d %H:%M"))
"    call append(7,"*")
"    call append(8,"* Filename:".expand("%:t"))
"    call append(9,"*")
"    call append(10,"* Description: ")
"    call append(11,"*")
"    call append(12,"=============================================================================*/")
"    echohl WarningMsg | echo "Successful in adding the copyright." | echohl None
"endf
""更新最近修改时间和文件名
"function UpdateTitle()
"    normal m'
"    execute '/* Last modified:/s@:.*$@\=strftime(":\t%Y-%m-%d %H:%M")@'
"    normal ''
"    normal mk
"    execute '/* Filename:/s@:.*$@\=":\t\t".expand("%:t")@'
"    execute "noh"
"    normal 'k
"    echohl WarningMsg | echo "Successful in updating the copy right." | echohl None
"endfunction
"判断前10行代码里面，是否有Last modified这个单词，
"如果没有的话，代表没有添加过作者信息，需要新添加；
"如果有的话，那么只需要更新即可
"function TitleDet()
"    let n=1
"    "默认为添加
"    while n < 10
"        let line = getline(n)
"        if line =~ '^\*\s*\S*Last\smodified:\S*.*$'
"            call UpdateTitle()
"            return
"        endif
"        let n = n + 1
"    endwhile
"    call AddTitle()
"endfunction
"

"添加header
function InsertHeadDef(firstLine, lastLine)
    if a:firstLine <1 || a:lastLine> line('$')
        echoerr 'InsertHeadDef : Range overflow !(FirstLine:'.a:firstLine.';LastLine:'.a:lastLine.';ValidRange:1~'.line('$').')'
        return ''
    endif
    let sourcefilename=expand("%:t")
    let definename=substitute(sourcefilename,' ','','g')
    let definename=substitute(definename,'\.','_','g')
    let definename = toupper(definename)
    exe 'normal '.a:firstLine.'GO'
    call setline('.', '#ifndef _'.definename."_")
    normal ==o
    call setline('.', '#define _'.definename."_")
    exe 'normal =='.(a:lastLine-a:firstLine+1).'jo'
    call setline('.', '#endif')
    let goLn = a:firstLine+2
    exe 'normal =='.goLn.'G'
endfunction
function InsertHeadDefN()
    let firstLine = 1
    let lastLine = line('$')
    let n=1
    while n < 20
        let line = getline(n)
        if n==1 
            if line =~ '^\/\*.*$'
                let n = n + 1
                continue
            else
                break
            endif
        endif
        if line =~ '^.*\*\/$'
            let firstLine = n+1
            break
        endif
        let n = n + 1
    endwhile
    call InsertHeadDef(firstLine, lastLine)
endfunction


function C_map ()
	imap <C-b>l <C-c>0i#include<space><
        set foldmethod=expr
	inoremap ( ()<esc>i
	inoremap [ []<esc>i
	inoremap { {<cr>}<esc>%a<cr>
	inoremap ' ''<esc>i
	inoremap " ""<esc>i
	map ,h	:A<cr>
	map ,H 	:AS<cr>
	map ,v 	:vs<cr>,h
	let Tlist_Ctags_Cmd = '/usr/local/bin/ctags'
	let Tlist_Show_One_File = 1            "不同时显示多个文件的tag，只显示当前文件的
	let Tlist_Exit_OnlyWindow = 1          "如果taglist窗口是最后一个窗口，则退出vim
	let Tlist_Use_Right_Window = 1         "在右侧窗口中显示taglist窗口
	
	:let mapleader = ","
	:map <Leader>tl	:Tlist<CR>
	":map <Leader>he i#ifndef<Esc>o#define<Esc>o#endif
	map <Leader>ha :call TitleDet()<cr>'s
	nmap ,ha :call InsertHeadDefN()<CR>
	set hlsearch
	"nmap ,so :w<cr>:so ~/.vimrc<cr>
	nmap <F2> :!ctags -R --fields=+lS<cr>
	nmap <F3> :args `find ./  -name '*.[hc]'  -print`<cr>
	nmap <F4> :ls<cr>
	nmap <F5> :source *.sess<cr>
	nmap <F8> :wa<cr>:!make<cr>
	nmap <F9> :wa<cr>:!make clean<cr>
	set cin
	set ts=4
	set sw=4
	set showmatch
	set matchtime=1
	
	
	" block map
	imap <C-b>i if({<cr><C-c>kkf(a
	imap <C-b>f (<cr>{<C-c>kkkf(a
	imap <C-b>c #ifdef<Tab>__cplusplus<cr>extern "C" {<cr>#endif<cr><cr><cr>#ifdef __cplusplus<cr>}<cr>#endif<C-c>kkkki
	imap <C-b>o for({<cr><cr><C-c>kkf(a
	imap <C-b>h while({<cr><cr><C-c>kkf(a
	imap <C-b>w do{<cr>while(<C-c>O
	imap <C-b>e if({<cr><cr>else{<cr><cr><C-c>kkkkf(a
	imap <C-b>m int main(<esc>i<cr>{<cr>return 0;<cr><C-c>kO
	imap <C-b>y <C-c>0itypedef struct <C-c>$a{<cr><C-c>O
	

endfunction
let g:neocomplcache_enable_at_startup = 1
autocmd BufNewFile,BufReadPost *.c,*.cc,*.h,*.cpp,*.html call C_map()
filetype indent on
set hlsearch
set tags=/home/zlx/code_hadoop/hadoop/input_formats/tags
set autoindent
set smartcase
set tabstop=4
set expandtab
set softtabstop=4
set shiftwidth=4
syntax on
