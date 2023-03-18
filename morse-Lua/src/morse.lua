
----- Morse encoder/decoder demo -----

-- separators for Morse words and tokens
sym_separ = " "    -- intra-symbol separator
tok_separ = "/"    -- Morse tokens separator

-- Morse converter table (A-Z, 0-9) --
-- Note(1): This can be implemented with two simple vectors
-- for encoding and decoding, this is just to be more compact.
-- Note(2): A tok_separ has been added to standard ITU in order
-- to enable simple string tokenizer and avoid using a full
-- parsing tree with variable look-ahead token length.
Morse_ITU = {
  -- text words and Morse tokens separators
  [" "] = tok_separ,

  -- tokens of length = 1
  ["E"] = ".",
  ["T"] = "-",

  -- tokens of length = 2
  ["I"] = "..",
  ["A"] = ".-",
  ["N"] = "-.",
  ["M"] = "--",

  -- tokens of length = 3
  ["S"] = "...",
  ["U"] = "..-",
  ["R"] = ".-.",
  ["D"] = "-..",
  ["W"] = ".--",
  ["K"] = "-.-",
  ["G"] = "--.",
  ["O"] = "---",

  -- tokens of length = 4
  ["H"] = "....",
  ["V"] = "...-",
  ["F"] = "..-.",
  ["L"] = ".-..",
  ["B"] = "-...",
  ["C"] = "-.-.",
  ["Z"] = "--..",
  ["P"] = ".--.",
  ["J"] = ".---",
  ["Q"] = "--.-",
  ["X"] = "-..-",
  ["Y"] = "-.--",

  -- tokens of length = 5
  ["1"] = ".----",
  ["2"] = "..---",
  ["3"] = "...--",
  ["4"] = "....-",
  ["5"] = ".....",
  ["6"] = "-....",
  ["7"] = "--...",
  ["8"] = "---..",
  ["9"] = "----.",  
  ["0"] = "-----"
}


----- main routine used for unit testing -----
print("Morse encoder/decoder demo\n")

-- Note: loops here can be further optimized with boolean
-- flag (shortcuts), but the overall complexity is linear
-- against message length N, since the translation table
-- and token lengths are fixed, i.e., O(N) in any case.
while true do
  -- step 1: read input from stdin
  local line = io.read()
  if (line == nil) then break end
  
  -- step 2: convert to uppercase and show
  str=line:upper()
  print(string.format("> Input: '%s'",str))
  
  -- step 3: encode in-place to Morse sequence
  for a, m in pairs(Morse_ITU) do
    --print(string.format("-> replacing %s with %s",a,m))
	-- replace text letters with Morse tokens
    str = string.gsub(str,a,m..sym_separ)
  end
  -- Note: some post-processing should be placed here
  --   to remove any invalid (non-ITU) characters
  --   which are left as-is in the encoded string  
  print(string.format("Encoded: '%s'",str))

  -- step 4: decode back to original text
  -- Note: The 'dot' and 'dash' used here are special
  --   characters for pattern-matching functions in Lua,
  --   making the use of string.gmatch() much more complex
  --   due to delicate regrexpr that need to be defined.
  --   Instead, some string.find() is standard and always
  --   available in every other programming language.
  dstr=""
  i=1
  j=string.find(str," ",i)
  while (i<=str:len()) and (j-i+1>0) do
    tok = string.sub(str,i,j-1)
    --print(string.format("token (%d,%d): '%s'",i,j,tok))
    for a, m in pairs(Morse_ITU) do
	  if tok==m then
	    dstr = dstr .. a
		break
	  end
	end
	-- Note: An additional flag 'found' can be used here
	--   to check if no conversion was made for current
	--   token, i.e., it contains invalid characters.
	--   Here, the token is simply ignored (no matching),
	--   thus destroying the next valid token in sequence.
	i=j+1
	j=string.find(str," ",i)
  end
  print(string.format("Decoded: '%s'\n",dstr))

end

