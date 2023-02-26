using Makie: @Block, CURRENT_DEFAULT_THEME

@Block LabelledToggleGrid begin
    @forwarded_layout
    toggles::Vector{Toggle}
    labels::Vector{Label}
    @attributes begin
        "The horizontal alignment of the block in its suggested bounding box."
        halign = :center
        "The vertical alignment of the block in its suggested bounding box."
        valign = :center
        "The width setting of the block."
        width = Auto()
        "The height setting of the block."
        height = Auto()
        "Controls if the parent layout can adjust to this block's width"
        tellwidth::Bool = true
        "Controls if the parent layout can adjust to this block's height"
        tellheight::Bool = true
        "The align mode of the block in its parent GridLayout."
        alignmode = Inside()
    end
end

function Makie.initialize_block!(sg::LabelledToggleGrid, nts::NamedTuple...)
    sg.toggles = Toggle[]
    sg.labels = Label[]

    for (i, nt) in enumerate(nts)
        label = haskey(nt, :label) ? nt.label : ""
        on_label = haskey(nt, :on_label) ? nt.on_label : label
		off_label = haskey(nt, :off_label) ? nt.off_label : label
        remaining_pairs = filter(pair -> pair[1] ∉ (:label, :on_label, :off_label), pairs(nt))
        toggle = Toggle(sg.layout[i, 2]; remaining_pairs...)
        label = Label(sg.layout[i, 1], lift(x -> x ? on_label : off_label, toggle.active), halign = :left)
        push!(sg.toggles, toggle)
        push!(sg.labels, label)
    end
end

@Block MenuGrid begin
    @forwarded_layout
    menus::Vector{Menu}
    labels::Vector{Label}
    @attributes begin
        "The horizontal alignment of the block in its suggested bounding box."
        halign = :center
        "The vertical alignment of the block in its suggested bounding box."
        valign = :center
        "The width setting of the block."
        width = Auto()
        "The height setting of the block."
        height = Auto()
        "Controls if the parent layout can adjust to this block's width"
        tellwidth::Bool = true
        "Controls if the parent layout can adjust to this block's height"
        tellheight::Bool = true
        "The align mode of the block in its parent GridLayout."
        alignmode = Inside()
    end
end

function Makie.initialize_block!(sg::MenuGrid, nts::NamedTuple...)
    sg.menus = Menu[]
    sg.labels = Label[]

    for (i, nt) in enumerate(nts)
        label = haskey(nt, :label) ? nt.label : ""
        remaining_pairs = filter(pair -> pair[1] ∉ (:label, :format), pairs(nt))
        menu = Menu(sg.layout[i, 2]; remaining_pairs...)
        lbl = Label(sg.layout[i, 1], label, halign = :left)
        push!(sg.menus, menu)
        push!(sg.labels, lbl)
    end
end