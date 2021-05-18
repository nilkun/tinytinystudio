" *** by nilkun ( www.nilkun.com ) ***  

function Handle_comments(comment_string)

endfunc

function Is_commented(comment_string)
  return len(matchstr(getline("."), '\_^\_s*'.a:comment_string))
endfunc

function Remove_comment(comment_string)
  return "^". len(a:comment_string). "x"
endfunc

function Add_comment(comment_string)
  return "normal!I".a:comment_string
endfunc

function Execute_comment_command(code)
  let l:lines = a:line_count
  while l:lines > 1
    exe "normal! j".a:code 
    let l:lines -= 1
  endif
endfunc

function Comment_toggle(line_count)
  let l:second_part = ""
  " handle exceptions first
  let l:has_second_part = 0
  let l:needs_regex = 0
  if &ft == 'vim'
    let l:comment = '" '
    let l:code = ""
    if Is_commented(l:comment)
      l:code = Remove_comment(l:comment)
    else
      l:code = Add_comment(l:comment)
    endif
    Execute_comment_command(l:code)
  " call setpos(".", l:current_pos)


  elseif &ft == 'cpp'
    let l:comment = '// '
  elseif &ft == 'scss'
    let l:comment = '// '
  elseif &ft == 'lua' 
    let l:comment = "-- "
  elseif &ft == 'haskell'
    let l:comment = "-- "
  elseif &ft == 'javascript'
    let l:comment = '// '
  elseif &ft == 'css'
    let l:comment = "/* "
    let l:second_part = " */"
    let l:needs_regex = "/[*] "
    let l:has_second_part = 1
    let l:needs_regex = " [*]/"
  elseif &ft == 'python'
    let l:comment = '# '
  elseif &ft == 'html'
    let l:comment = "<!-- "
    let l:second_part = " -->"
    let l:has_second_part = 1
  else
    " DEFAULT
    let l:comment = '# '
  endif

  " STORE THE CURRENT CURSOR POSITION
  let l:current_pos = getpos(".")

  " CHECK IF LINE IS COMMENTED
  " let l:comment_regex =
  "if l:needs_regex
  "  let l:string_l = l:needs_regex
  "else
  " let l:string_l = l:comment
  "endif
  let l:is_commented = len(matchstr(getline("."), '\_^\_s*'.l:comment))
  " "/***** hello word
  if l:is_commented
    " MOVE THE CURSOR BACK AND UNCOMMENT THE LINE
    let l:code = "^". len(l:comment). "x"
    if l:has_second_part
      "        if l:needs_regex2
      "         l:string_l2 = l:needs_regex
      "     else
      "       l:string_l2 = l:has_second_part
      "    endif
      let l:second_part = "$". (len(l:second_part)-1). "Xx"
    endif
    let l:current_pos[2] -= len(l:comment)
  else
    " MOVE THE CURSOR FORWARD AND COMMENT THE CURRENT LINE
    let l:current_pos[2] += len(l:second_part)
    let l:code = "I". l:comment
    if l:has_second_part
      let l:second_part = "A". l:second_part
    endif
  endif

  " EXECUTE CODE
  exe "normal! ".l:code
  if l:has_second_part
    exe "normal! ".l:second_part
  endif

  let l:lines = a:line_count
  while l:lines > 1
    exe "normal! j".l:code 
    if l:has_second_part 
      exe "normal! ".l:second_part
    endif
    let l:lines -= 1
  endwhile

  " CLEAR COMMAND LINE
  echo ""

  " RESTORE CURSOR POSITION
  call setpos(".", l:current_pos)
endfunction
