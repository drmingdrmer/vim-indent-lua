" Vim indent file
" Language:	Lua script
" Maintainer:	Zhang Yanpo <drdr.xp 'at' gmail.com>
" First Author:	Zhang Yanpo <drdr.xp 'at' gmail.com>
" Last Change:	2016 Aug 19

if exists("b:did_indent")
    finish
endif
let b:did_indent = 1

setlocal indentexpr=GetLuaIndent()

" To make Vim call GetLuaIndent() when it finds '\s*end' or '\s*until'
" on the current line ('else' is default and includes 'elseif').
setlocal indentkeys+=0=end,0=until

setlocal autoindent

" Only define the function once.
if exists("*GetLuaIndent")
    finish
endif


let s:lua_start = '\v%(<do>|<then>|<repeat>|<function>|[{(])'
let s:lua_mid = '\v%(<else>)'
let s:lua_end = '\v%(<end>|<elseif>|<until>|[)}])'

" start and mid
let s:lua_left = '\v%(<do>|<then>|<repeat>|<function>|<else>|[{(])'

let s:lua_pairs = {
    \ 'function' : '\v<end>',
    \ 'repeat' : '\v<until>',
    \ 'then' : '\v%(<else>|<elseif>|<end>)',
    \ 'else' : '\v%(<end>)',
    \ 'do' : '\v<end>',
    \ '{' : '\v[}]',
    \ '(' : '\v[)]',
    \ }

let s:lua_follow_align = {
    \ 'do' : 1,
    \ 'then' : 1,
    \ 'repeat' : 1,
    \ '{' : 1,
    \ '(' : 1,
    \ 'else' : 1,
    \ }

" only need to indent continuous line in a multi expression block
let s:lua_single_expr_block = {
    \ '{' : 1,
    \ '(' : 1,
    \ }

let s:lua_indent = {
    \ '(' : 2,
    \ }

let s:lua_trailing_op = '\v[,=\\+\-*/]\s*$'

let s:skiplines = "synIDattr(synID(line('.'), col('.'), 1), 'name') =~ '\\(Comment\\|String\\)$'"


function! GetLuaIndent()

    " function foo(x,    <-- prev ref line, the starting line of a bracket block
    "              y)    <-- prev line, last non-blank line
    "
    "     local a = 1    <-- we are here
    " end

    let prev_ln = prevnonblank(v:lnum - 1)

    if prev_ln == 0
        return 0
    endif

    let block_pos = s:find_container_block([v:lnum, 1])
    call s:dd('find block pos: ' . string(block_pos))

    if block_pos[0] > 0

        let _matched = getline(block_pos[0])[block_pos[1] - 1 : ]
        call s:dd('_matched: ' . _matched)

        let matched = matchstr(_matched, s:lua_left)
        let trailing = _matched[len(matched) : ]

        call s:dd('block left:' . matched)
        call s:dd('trailing:' . trailing)

        return s:get_indent_in_block(block_pos, matched, trailing)
    else
        let _ind = s:continuous_line_indent(v:lnum)
        call s:dd('continuous line indent: ' . _ind)
        if _ind != -9999
            return _ind
        end

        let container_pos = [0, 0]

        let cur = prevnonblank(v:lnum - 1)
        if cur == 0
            return 0
        endif

        let pos = s:find_child_block([cur, 1], container_pos)

        let head_ln = s:find_continous_head(pos[0])
        return indent(head_ln)
    endif

endfunction


fun! s:dd(msg) "{{{
    " echom a:msg
endfunction "}}}


fun! s:is_literal(ln, col) "{{{
    let synname = synIDattr(synID(a:ln, a:col, 1), "name")
    return synname =~ '\vComment|String'
endfunction "}}}


fun! s:get_indent_in_block(matched_pos, matched, trailing) "{{{

    let sw = &shiftwidth
    let m = a:matched
    let t = a:trailing

    let container_pos = s:find_container_block(a:matched_pos)
    let pos = s:find_child_block([a:matched_pos[0], 1], container_pos)
    let ref_ind = indent(pos[0])

    " if it is 'end' for a 'function', or 'end' for a 'then'
    let endpart = s:lua_pairs[m]
    if getline(v:lnum) =~ '\v^\s*' . endpart
        return ref_ind
    endif

    " function(a,
    "          b)
    " or
    " function(a,
    "     b)
    if has_key(s:lua_follow_align, m)
        if t !~ '\v^\s*$'
            return a:matched_pos[1] - 1 + len(m) + len(matchstr(t, '\v^\s?'))
        end
    endif

    " in block indent

    " find the start of a expression in a multi-line block, like function-end
    " or if () then-end.
    " but not for {}
    if ! has_key(s:lua_single_expr_block, m)
        let _ind = s:continuous_line_indent(v:lnum)
        if _ind != -9999
            return _ind
        end
    endif

    " indent each line in a block, count in unit 'shiftwidth'
    let ind = get(s:lua_indent, m, 1)
    return ref_ind + sw * ind

endfunction "}}}


fun! s:find_child_block(pos, container_pos) "{{{

    let pos = a:pos
    call s:dd('find_child_block from:' . string(pos) . ' container: ' . string(a:container_pos))

    while 1
        let parent_pos = s:find_container_block(pos)

        call s:dd('parent_pos: ' . string(parent_pos))

        if parent_pos == a:container_pos
            return pos
        endif

        if parent_pos[0] < a:container_pos[0]
              \ || (parent_pos[0] == a:container_pos[0]
              \     && parent_pos[1] < a:container_pos[1])
            call s:dd('reached upper level: ' . string(parent_pos))
            return pos
        endif

        let pos = parent_pos

    endwhile

endfunction "}}}


" NOTE: searching backward from at end '}' fails to find the pair
"       And searching forward from the leading '{' fails to find the pair.
fun! s:find_container_block(pos) "{{{
    call cursor(a:pos)
    return searchpairpos(s:lua_start, s:lua_mid, s:lua_end, 'bWn', s:skiplines)
endfunction "}}}


fun! s:continuous_line_indent(cur_ln) "{{{
    let sw = &shiftwidth
    let head_ln = s:find_continous_head(a:cur_ln)

    if head_ln == a:cur_ln
        return -9999
    else
        return indent(head_ln) + sw * 2
    endif

endfunction "}}}


fun! s:find_continous_head(cur_ln) "{{{

    let cur_ln = a:cur_ln
    call s:dd('looking for trailing_op: from: ' . cur_ln)

    while 1

        let prev_ln = prevnonblank(cur_ln - 1)

        if getline(prev_ln) =~ s:lua_trailing_op
            \  && ! s:is_literal(prev_ln, col([prev_ln, '$']) - 1)

            let cur_ln = prev_ln
        else
            break
        endif
    endwhile

    return cur_ln

endfunction "}}}

" vim: sw=4
