let s:alicebob = {
      \'a':['Alice', 'Albert'],
      \'b':['Bob', 'Brenda'],
      \'c':['Carol', 'Carl'],
      \'d':['Dave', 'Diana'],
      \'e':['Eve', 'Eric'],
      \'f':['Frank', 'Faythe'],
      \'g':['Grace', 'George'],
      \'h':['Heidi', 'Harris'],
      \'i':['Ivan', 'Iris'],
      \'j':['Judy', 'Justin'],
      \'k':['Kevin', 'Kate'],
      \'l':['Linda', 'Lewis'],
      \'m':['Mallory', 'Mike'],
      \'n':['Natalie', 'Nelson'],
      \'o':['Olivia', 'Oscar'],
      \'p':['Peggy', 'Pat'],
      \'q':['Quentin', 'Quincy'],
      \'r':['Rupert', 'Rachel'],
      \'s':['Steve', 'Sherry'],
      \'t':['Ted', 'Tabby'],
      \'u':['Uriah', 'Urien'],
      \'v':['Victor', 'Vanna'],
      \'w':['Walter', 'Wendy'],
      \'x':['Xavier', 'Ximena'],
      \'y':['York', 'Yolanda'],
      \'z':['Zoe', 'Zadoc'],
      \}

let s:lorem_ipsum = [
      \'Lorem ipsum dolor sit amet,',
      \'consectetur adipiscing elit,',
      \'sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
      \'Ut enim ad minim veniam,',
      \'quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
      \'Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.',
      \'Excepteur sint occaecat cupidatat non proident,',
      \'sunt in culpa qui officia deserunt mollit anim id est laborum.',
      \'',
      \'Curabitur pretium tincidunt lacus.',
      \'Nulla gravida orci a odio.',
      \'Nullam varius,',
      \'turpis et commodo pharetra,',
      \'est eros bibendum elit,',
      \'nec luctus magna felis sollicitudin mauris.',
      \'Integer in mauris eu nibh euismod gravida.',
      \'Duis ac tellus et risus vulputate vehicula.',
      \'Donec lobortis risus a elit.',
      \'Etiam tempor.',
      \'Ut ullamcorper,',
      \'ligula eu tempor congue,',
      \'eros est euismod turpis,',
      \'id tincidunt sapien risus a quam.',
      \'Maecenas fermentum consequat mi.',
      \'Donec fermentum.',
      \'Pellentesque malesuada nulla a mi.',
      \'Duis sapien sem,',
      \'aliquet nec,',
      \'commodo eget,',
      \'consequat quis,',
      \'neque.',
      \'Aliquam faucibus,',
      \'elit ut dictum aliquet,',
      \'felis nisl adipiscing sapien,',
      \'sed malesuada diam lacus eget erat.',
      \'Cras mollis scelerisque nunc.',
      \'Nullam arcu.',
      \'Aliquam consequat.',
      \'Curabitur augue lorem,',
      \'dapibus quis,',
      \'laoreet et,',
      \'pretium ac,',
      \'nisi.',
      \'Aenean magna nisl,',
      \'mollis quis,',
      \'molestie eu,',
      \'feugiat in,',
      \'orci.',
      \'In hac habitasse platea dictumst.',
      \]
let s:lorem_ipsum_len = len(s:lorem_ipsum)

let s:foobar = [
      \'foo',
      \'bar',
      \'baz',
      \'qux',
      \'quux',
      \'corge',
      \'grault',
      \'garply',
      \'waldo',
      \'fred',
      \'plugh',
      \'xyzzy',
      \'thud',
      \]
let s:foobarlen = len(s:foobar)

function s:parse_query(key) abort
  if empty(a:key)
    return ''
  endif

  let key = tolower(a:key)
  let len = strchars(key)

  " foobar
  let list = matchlist(key, '^\(\d\+\)$')
  if !empty(list)
    let nr = list[1]

    return { 'type':'foobar', 'args': [nr] }
  endif

  " alice bob
  let list = matchlist(key, '^\(\l\)\(1\|2\)\=$')
  if !empty(list)
    let alphabet = list[1]
    let nr = list[2]

    if empty(nr)
      let nr = 1
    endif
    return { 'type': 'people', 'args': [ alphabet, nr - 1 ] }
  endif

  let list = matchlist(key, '^\(li\|lorem\|loremipsum\)\(\d*\)$')
  if !empty(list)
    let nr = list[2]
    if empty(list[2])
      let nr = 0
    endif
    return { 'type': 'loremipsum', 'args': [nr] }
  else
    return { 'type': 'nextfoobar', 'args': [ key ] }
  endif
endfunction

function foobar#foobar(ordinal) abort
  if a:ordinal <= 0
    return ''
  elseif a:ordinal <= s:foobarlen
    return s:foobar[a:ordinal - 1]
  else
    return ''
  endif
endfunction

function foobar#foobar_next(foo) abort
  let ordinal = foobar#get_foobar_ordinal(a:foo)
  if ordinal == 0
    return ''
  else
    return foobar#foobar(ordinal + 1)
  endif
endfunction

function foobar#get_foobar_ordinal(foo) abort
  let foo = tolower(a:foo)
  let index = index(s:foobar, a:foo)
  if index == -1
    return 0
  else
    return index + 1
  endif
endfunction

function foobar#people(firstchar, alt) abort
  if a:alt != 0 && a:alt != 1
    echoerr 'invalid arguments'
  endif

  let list = get(s:alicebob, a:firstchar, '')
  if !empty(list)
    return list[a:alt]
  else
    " undefined
    return ''
  endif
endfunction

function foobar#lorem_ipsum(sentences) abort
  if a:sentences <= 0 || a:sentences > s:lorem_ipsum_len
    let sentences = s:lorem_ipsum_len
  else
    let sentences = a:sentences
  endif

  return join(s:lorem_ipsum[0:(sentences-1)], "\n")
endfunction

function foobar#query(key) abort
  let params = s:parse_query(a:key)

  if empty(params)
    " undefined
    return ''
  endif

  let type = get(params, 'type')
  let args = get(params, 'args')

  if type ==# 'foobar'
    return foobar#foobar(args[0])
  elseif type ==# 'people'
    return foobar#people(args[0], args[1])
  elseif type ==# 'nextfoobar'
    return foobar#foobar_next(args[0])
  elseif type ==# 'loremipsum'
    return foobar#lorem_ipsum(args[0])
  else
    echoerr 'unknown type'
  endif
endfunction

function! foobar#_echo_undefined_query_key(query, id) abort
  echo '[foobar] undefined query key:' a:query
endfunction
