local config = {
    window = {}
}

config.renderers =
{
    file = {
        { 'indent'  },
        { 'marked'  },
        { 'icon'    },
        { 'name'    }
    },
    directory = {
        { 'indent'  },
        { 'marked'  },
        { 'icon'    },
        { 'expanded'},
        { 'name'    }
    },
    netman_provider = {
        { 'indent'  },
        { 'expanded'},
        { 'icon'    },
        { 'name'    }
    },
    netman_host = {
        { 'indent'  },
        { 'expanded'},
        { 'state'   },
        { 'icon'    },
        { 'name'    }
    },
    netman_bookmark = {
        { 'indent' },
        { 'icon'   },
        { 'name'   }
    },
    netman_stop    = {
        { 'indent' },
        { 'icon'   },
        { 'name'   },
        { 'action' }
    },
}

config.window.mappings = {
    -- ['g'] = "toggle_favorite",
    ['x'] = 'move_node',
    ['p'] = 'paste_node',
    ['m'] = 'mark_node',
    ['u'] = 'unmark_all_nodes',
    ['y'] = "yank_node",
    -- Note, hosts open a terminal via open_split/open_vsplit (S/s by default), so
    -- open_terminal_split/open_terminal_vsplit are intentionally left unmapped here
    -- ['f'] = 'search'
}

return config
