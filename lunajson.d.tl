--[[ this is incomplete, only the basics have been done so it works in the code ]]
global type lunajsonmodule = record
	decode: function(string): {string: any}
	encode: function({string: any}): string
end

return lunajsonmodule