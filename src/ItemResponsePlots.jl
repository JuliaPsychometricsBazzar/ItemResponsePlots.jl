"""
This module provides plots for fitted item banks in Julia
"""
module ItemResponsePlots

using Makie
using FittedItemBanks
using FittedItemBanks: item_bank_domain, DichotomousPointsItemBank

export plot_item_bank

include("./widgets.jl")

struct LabelVecLabeller
	arr::Vector{String}
end

function (lv::LabelVecLabeller)(index::Int)
	lv.arr[index]
end

function index_labeller(index::Int)
    "Item $index"
end
#=
	toggles = Array{Toggle}(undef, length(item_bank))
	for idx in eachindex(item_bank)
		label = labeller(idx)
		toggles[idx] = (off_label = "Show $name", on_label="Hide $name", active = true)
	end
	#ir = ItemResponse(item_bank, idx)
	ltgrid = LabelledToggleGrid(
		fig[1, 2],
		toggles...,
		width = 350,
		tellheight = false
	)
	#GridLayout()
	ltgrid
=#

function _item_bank_domain(::OneDimContinuousDomain, item_bank, items; zero_symmetric=false)
	item_bank_domain(item_bank; items=items, zero_symmetric=zero_symmetric)
end

function _item_bank_domain(::VectorContinuousDomain, item_bank, items; zero_symmetric=false)
	nd = domdims(item_bank)
	item_bank_domain(item_bank; items=items, zero_symmetric=zero_symmetric)
end

function plot_item_bank(item_bank::AbstractItemBank; items=eachindex(item_bank), labeller=index_labeller, zero_symmetric=false)
	fig = Figure()
	ax = Axis(fig[1, 1])
	lim_lo, lim_hi = _item_bank_domain(DomainType(item_bank), item_bank, items; zero_symmetric=zero_symmetric)
	@info "lims" lim_lo, lim_hi
	xlims!(lim_lo, lim_hi)
	xs = range(lim_lo, lim_hi, length = 100)
	ys = Array{Float64}(undef, length(xs), 2)
	outcomes = Array{Makie.Lines}(undef, 2, length(items))
	for (ii, item) in enumerate(items)
		ir = ItemResponse(item_bank, item)
		for (i, x) in enumerate(xs)
			ys[i, :] .= resp_vec(ir, x)
		end
		@info "data" xs ys

		for out in [1, 2]
			outcomes[out, ii] = lines!(ax, xs, @view ys[:, out])
		end
	end
	toggles = []
	for out in [1, 2]
		push!(toggles, (off_label = "Show $out", on_label="Hide $out", active = true))
	end
	grid = LabelledToggleGrid(
		fig[1, 2],
		toggles...,
		width = 350,
		tellheight = false
	)
	for (i, toggle) in enumerate(grid.toggles)
		for j in eachindex(items)
			connect!(outcomes[i, j].visible, toggle.active)
		end
	end
	axislegend("Legend", position = :rb);
	fig
end

function plot_item_bank(item_bank::DichotomousPointsItemBank; items=eachindex(item_bank), labeller=index_labeller, zero_symmetric=false)
	fig = Figure()
	ax = Axis(fig[1, 1])
	#lo = item_bank.xs[1]
	#hi = item_bank.xs[end]
	for item in items
		scatter!(ax, item_bank.xs, @view item_bank.ys[item, :]; markersize=5, marker=:cross)
	end
	fig
end

end
