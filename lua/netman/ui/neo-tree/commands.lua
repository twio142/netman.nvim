--This file should contain all commands meant to be used by mappings.
local input = require("neo-tree.ui.inputs")
local cc = require("neo-tree.sources.common.commands")
local ui = require("netman.ui.neo-tree")
local M = {}

local do_callback = function(callback)

    if callback and type(callback) == 'function' then callback() end
end
--- This will reach out to an internal function for handling subtree navigation (ish?)
M.open = function(state, callback)
    -- Probably should figure out how to get this to handle splits and such first?
    ui.navigate(state)
    do_callback(callback)
end

-- TODO: Actually implement whatever this is...?
M.open_with_window_picker = M.open

-- TODO:
M.add_directory = function(state, callback)
    ui.add(state, {force_dir = true})
    do_callback(callback)
end

M.add = function(state, callback)
    ui.add(state)
    do_callback(callback)
end

M.refresh = function(state, callback)
    ui.refresh(state)
    do_callback(callback)
end

M.rename = function(state, callback)
    ui.rename(state)
    do_callback(callback)
end

M.delete = function(state, callback)
    ui.delete(state)
    do_callback(callback)
end

M.yank_node = function(state, callback)
    ui.set_mark_action(state, 'copy')
    -- TODO: Add copying the node(s) names to a register?
    do_callback(callback)
end

M.move_node = function(state, callback)
    ui.set_mark_action(state, 'move')
    do_callback(callback)
end

M.search = function(state, callback)
    ui.search(state)
    do_callback(callback)
end

M.mark_node = function(state, callback)
    ui.mark_node(state)
    do_callback(callback)
end

M.mark_node_visual = function(state, selected_nodes, callback)
    ui.mark_node_visual(state, selected_nodes)
    do_callback(callback)
end

-- Note, unmark_node with no node given clears every mark, not just one
M.unmark_all_nodes = function(state, callback)
    ui.unmark_node(state)
    do_callback(callback)
end

M.paste_node = function(state, callback)
    ui.paste_node(state)
    do_callback(callback)
end

--- Opens whatever is relevant for the node under the cursor in a new window.
--- Hosts have no contents of their own to display, so they get a terminal
--- connected to them instead. Everything else is navigated as usual
--- @param state table
---     The neo-tree state
--- @param split_cmd string
---     The vim command to create the new window with (EG "split", "vsplit")
local open_or_terminal = function(state, split_cmd)
    local node = state.tree and state.tree:get_node()
    if
        node
        and node.type == ui.constants.TYPES.NETMAN_HOST
        -- A provider isn't required to tell us how to get a shell on its hosts. If this
        -- one didn't, fall through and treat the host like any other node
        and ui.open_terminal(state, split_cmd, node)
    then
        return
    end
    ui.navigate(state, nil, split_cmd)
end

--- Opens the node in a horizontal split. Hosts open a terminal,
--- directory-ish nodes are simply expanded/collapsed
M.open_split = function(state, callback)
    open_or_terminal(state, "split")
    do_callback(callback)
end

--- Opens the node in a vertical split. Hosts open a terminal,
--- directory-ish nodes are simply expanded/collapsed
M.open_vsplit = function(state, callback)
    open_or_terminal(state, "vsplit")
    do_callback(callback)
end

--- Opens the node in a new tab. Directory-ish nodes are simply expanded/collapsed
M.open_tabnew = function(state, callback)
    ui.navigate(state, nil, "tabnew")
    do_callback(callback)
end

--- Opens a terminal connected to the host under the cursor in a horizontal split
M.open_terminal_split = function(state, callback)
    ui.open_terminal(state, "split")
    do_callback(callback)
end

--- Opens a terminal connected to the host under the cursor in a vertical split
M.open_terminal_vsplit = function(state, callback)
    ui.open_terminal(state, "vsplit")
    do_callback(callback)
end

-- -- TODO:
-- M.open_drop = function(state, callback)
--
-- end
--
-- -- TODO:
-- M.open_tab_drop = function(state, callback)
--
-- end

-- -- TODO:
-- M.open_with_window_picker = function(state, callback)
--
-- end
--
-- -- TODO:
-- M.split_with_window_picker = function(state, callback)
--     
-- end
--
-- -- TODO:
-- M.vsplit_with_window_picker = function(state, callback)
--
-- end

-- -- TODO:
-- M.copy = function(state, callback)
--
-- end
--
-- -- TODO:
-- M.copy_to_clipboard = function(state, callback)
--
-- end
--
-- -- TODO:
-- M.copy_to_clipboard_visual = function(state, callback)
--
-- end
--
-- -- TODO:
-- M.move = function(state, callback)
--
-- end
--
-- TODO:

-- M.cut_to_clipboard = function(state, callback)
--     local node = state.tree:get_node()
--     return M.cut_to_clipboard_visual(state, {node}, callback)
-- end
-- --
-- -- TODO:
-- -- Takes the selected nodes and "marks" them as cut.
-- M.cut_to_clipboard_visual = function(state, selected_nodes, callback)
--     ui.clear_marked_nodes()
--     local message = string.format("Marked %s nodes for move", #selected_nodes)
--     local status = {}
--     for _, node in ipairs(selected_nodes) do
--         status = ui.mark_node(node, ui.constants.MARK.cut)
--         if not status.success then
--             message = status.error
--         end
--     end
--     logger.warnn(message)
--     do_callback(callback)
-- end
--
-- M.paste_from_clipboard = function(state, callback)
--     local node = state.tree:get_node()
--     if not node.extra then
--         logger.infon(string.format("%s is not a valid Netman Node. Cannot paste here", node.name))
--         return
--     end
--
--     local message = string.format("Are you sure you want to paste in %s [y/N]", node.name)
--     local default = "Y"
--     local confirm_callback = function(response)
--         if not response:match('^[yY]') then
--             return
--         end
--         ui.process_marked_nodes(state, {
--             ui.constants.MARK.cut,
--             ui.constants.MARK.copy
--         })
--         do_callback(callback)
--     end
--     input.input(message, default, confirm_callback)
-- end
--
--
--
-- -- TODO:
-- M.delete_visual = function(state, selected_nodes, callback)
--     for _, node in pairs(selected_nodes) do
--         M.delete(state, node)
--     end
--     do_callback(callback)
-- end

-- M.toggle_favorite = function(state, callback)
--     local tree = state.tree
--     if not tree then return end
--     local internal_node = require("netman.ui.neo-tree").internal.get_internal_node(tree:get_node():get_id())
--     if not internal_node.host then return end
--     require("netman.ui.neo-tree").favorite_toggle(internal_node.provider, internal_node.host)
--     if callback and type(callback) == 'function' then callback() end
-- end
--  
-- -- TODO:
-- M.toggle_hidden = function(state, callback)
--     local tree = state.tree
--     if not tree then return end
--     local internal_node = require("netman.ui.neo-tree").internal.get_internal_node(tree:get_node():get_id())
--     if not internal_node.host then return end
--     require("netman.ui.neo-tree").hide_toggle(internal_node.provider, internal_node.host)
--     if callback and type(callback) == 'function' then callback() end
-- end

cc._add_common_commands(M)
return M
