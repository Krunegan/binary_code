--[[

The MIT License (MIT)
Copyright (C) 2024 Flay Krunegan

Permission is hereby granted, free of charge, to any person obtaining a copy of this
software and associated documentation files (the "Software"), to deal in the Software
without restriction, including without limitation the rights to use, copy, modify, merge,
publish, distribute, sublicense, and/or sell copies of the Software, and to permit
persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or
substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
DEALINGS IN THE SOFTWARE.

]]

local function text_to_binary(player_name, input_text)
    local binary = ""
    for i = 1, #input_text do
        local char = input_text:sub(i, i)
        local byte = string.byte(char)
        local binary_char = ""
        for j = 7, 0, -1 do
            binary_char = binary_char .. tostring(bit.band(byte, 2^j) > 0 and 1 or 0)
        end
        binary = binary .. binary_char .. " "
    end
    minetest.show_formspec(player_name, "binary_code:result",
        "size[8,8]"..
        "label[0,0;" .. "# "..minetest.colorize("orange", "TEXT TO BINARY").."]"..
        "box[-0.1,-0.1;8,0.7;black]"..
        "box[-0.1,0.7;8,7.4;#030303]"..
        "textarea[0.2,0.7;8,7.4;;;" .. binary .. "]"
    )
end

local function binary_to_text(player_name, input_binary)
    local text = ""
    local binary_chars = input_binary:split(" ")
    for _, binary_char in ipairs(binary_chars) do
        if binary_char ~= "" then
            local byte = 0
            for i = 1, 8 do
                byte = byte * 2 + tonumber(binary_char:sub(i, i))
            end
            text = text .. string.char(byte)
        end
    end
    minetest.show_formspec(player_name, "binary_code:result",
        "size[8,8]"..
        "label[0,0;" .. "# "..minetest.colorize("orange", "BINARY TO TEXT").."]"..
        "box[-0.1,-0.1;8,0.7;black]"..
        "box[-0.1,0.7;8,7.4;#030303]"..
        "textarea[0.2,0.7;8,7.4;;;" .. text .. "]"
    )
end

minetest.register_chatcommand("binary", {
    params = "<text>",
    description = "Translate text to binary",
    func = function(name, param)
        text_to_binary(name, param)
    end,
})

minetest.register_chatcommand("unbinary", {
    params = "<binary sequence>",
    description = "Translate binary to text",
    func = function(name, param)
        binary_to_text(name, param)
    end,
})
