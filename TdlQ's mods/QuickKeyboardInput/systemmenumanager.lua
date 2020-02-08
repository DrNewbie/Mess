local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

core:module('SystemMenuManager')

QuickKeyboardInputDialog = QuickKeyboardInputDialog or class(GenericDialog)
QuickKeyboardInputDialog.PANEL_SCRIPT_CLASS = 'QuickKeyboardInputGui'

GenericSystemMenuManager.GENERIC_KEYBOARD_INPUT_DIALOG = QuickKeyboardInputDialog
GenericSystemMenuManager.KEYBOARD_INPUT_DIALOG = QuickKeyboardInputDialog

function QuickKeyboardInputDialog:update_input()
	-- qued
end
