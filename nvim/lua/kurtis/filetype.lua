-- ============================================================================
-- PICK BASIC FILETYPE DETECTION (extensionless files)
-- ============================================================================
vim.filetype.add({
  -- Detect extensionless files as Pick BASIC by inspecting content
  pattern = {
    [".*"] = {
      priority = -math.huge, -- lowest priority so it never overrides real detections
      function(path, bufnr)
        -- Skip files that already have a recognizable extension
        local ext = vim.fn.fnamemodify(path, ":e")
        if ext ~= "" then
          return nil
        end

        -- Read the first 500 lines and look for Pick BASIC patterns
        local lines = vim.api.nvim_buf_get_lines(bufnr, 0, 500, false)
        local joined = table.concat(lines, "\n")
        local upper = joined:upper()

        -- Pick BASIC keywords (case-insensitive match on joined text)
        local keywords = {
          "SUBROUTINE", "GOSUB", "RETURN", "CRT ", "PRINT ",
          "OPEN ", "READ ", "WRITE ", "READV ", "WRITEV ",
          "MATREAD", "LOCATE ", "EQUATE ", "EQU ",
          "EXECUTE ", "CALL ", "DEFFUN ",
        }
        local score = 0
        for _, kw in ipairs(keywords) do
          if upper:find(kw) then
            score = score + 1
          end
        end

        -- Also check for common Pick BASIC comment style (* at line start)
        for _, line in ipairs(lines) do
          if line:match("^%s*%*") or line:match("^%s*!%s") then
            score = score + 1
          end
        end

        if score >= 2 then
          return "basic"
        end
        return nil
      end,
    },
  },
})
