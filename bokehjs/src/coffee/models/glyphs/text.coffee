_ = require "underscore"

Glyph = require "./glyph"
p = require "../../core/properties"

class TextView extends Glyph.View

  _index_data: () ->
    @_xy_index()

  _render: (ctx, indices, {sx, sy, x_offset, y_offset, angle, text}) ->
    for i in indices
      if (isNaN(sx[i]+sy[i]+x_offset[i]+y_offset[i]+angle[i]) or not text[i]?)
        continue

      if @visuals.text.doit
        ctx.save()
        ctx.translate(sx[i]+x_offset[i], sy[i]+y_offset[i])
        ctx.rotate(angle[i])

        @visuals.text.set_vectorize(ctx, i)
        ctx.fillText(text[i], 0, 0)
        ctx.restore()

  draw_legend: (ctx, x1, x2, y1, y2) ->
    ctx.save()
    @text_props.set_value(ctx)
    # override some features so we fit inside the legend
    ctx.font = @text_props.font_value()
    ctx.font = ctx.font.replace(/\b[\d\.]+[\w]+\b/, '10pt')
    ctx.textAlign = "right"
    ctx.textBaseline = "middle"
    ctx.fillText("text", x2, (y1+y2)/2)
    ctx.restore()

class Text extends Glyph.Model
  default_view: TextView

  type: 'Text'

  mixins: ['text']

  props: ->
    return _.extend {}, super(), {
      text:     [ p.StringSpec, { field :"text" } ]
      angle:    [ p.AngleSpec,  0                 ]
      x_offset: [ p.NumberSpec, 0                 ]
      y_offset: [ p.NumberSpec, 0                 ]
    }

module.exports =
  Model: Text
  View: TextView
