-- split-code.lua — Spezza blocchi di codice lunghi per EPUB
-- I reader EPUB non riescono a paginare un singolo <pre> che supera
-- la pagina: lo tagliano. Questo filtro divide i CodeBlock con più
-- di MAX_LINES righe in chunk consecutivi, ciascuno racchiuso nel
-- proprio <pre>, così il reader può inserire un page-break fra un
-- chunk e l'altro.

local MAX_LINES = 32  -- righe massime per chunk

function CodeBlock(elem)
  local lines = {}
  for line in (elem.text .. "\n"):gmatch("(.-)\n") do
    table.insert(lines, line)
  end

  -- Rimuovi ultima riga vuota aggiunta dal pattern
  if #lines > 0 and lines[#lines] == "" then
    table.remove(lines)
  end

  if #lines <= MAX_LINES then
    return nil  -- nessuna modifica
  end

  local blocks = {}
  local lang = elem.classes[1] or ""

  for i = 1, #lines, MAX_LINES do
    local chunk = {}
    for j = i, math.min(i + MAX_LINES - 1, #lines) do
      table.insert(chunk, lines[j])
    end
    local text = table.concat(chunk, "\n")
    local cb = pandoc.CodeBlock(text, elem.attr)

    -- Aggiungi un piccolo separatore visivo tra i chunk (tranne il primo)
    if #blocks > 0 then
      table.insert(blocks, pandoc.RawBlock("html",
        '<div style="border-top:1px dashed #ccc; margin:0; padding:0;"></div>'))
    end
    table.insert(blocks, cb)
  end

  return blocks
end
