#!/usr/bin/env ruby
# coding: utf-8

require 'erb'

Card = Struct.new :suit, :value do
  def color
    SUITS[suit] || '#000000'
  end

  def binding_
    binding
  end

  def factor; 3; end
  def height; 1122 * factor; end
  def width; 822 * factor; end
  def bleed; 36 * factor; end
  def safe; bleed + (36 * factor); end
  def margin; safe; end
  def corner_size; 120 * factor; end
  def center_size; 300 * factor; end
  def center_margin; 40 * factor; end
  def debug; ENV['DEBUG']; end
end

SUIT_CARDS = %w[0 1 2 3 4 5 6 7 8 9 A B C D E F T J Q K]

SUITS = {
  '♠' => '#006064',
  '♥' => '#B71C1C',
  '♣' => '#1B5E20',
  '♦' => '#01579B',
  '★' => '#F57F17',
  'Ψ' => '#4A148C',
}

#%w[                   ]
#
#♠♥♣♦

EXTRAS = %w[♔ ♚ ♕ ♛ ♖ ♜ ♗ ♝ ♘ ♞ ♙ ♟] +
         (%w[☠ ≶ ⇢] * 4).sort #  ○ ● ☺ ☹

CARDS = (SUITS.keys.product(SUIT_CARDS) +
         [nil].product(EXTRAS)).map { |i| Card.new *i }

TEMPLATE = ERB.new DATA.read

CARDS.each_with_index do |c, i|
  File.open "#{i}.svg", 'w' do |f|
    f.write TEMPLATE.result c.binding_
  end
end

__END__
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"
     version="1.1" width="<%=width%>" height="<%=height%>" viewBox="0 0 <%=width%> <%=height%>">
  <defs>
    <g id="half">
      <text
        text-anchor="start"
        style="font-family:'PragmataPro';font-size:<%=corner_size%>;"
        fill="<%=color%>"
        x="<%=margin%>" y="<%=margin%>"><tspan
          x="<%=margin%>" dy="<%=corner_size%>"><%=value%></tspan><tspan
          x="<%=margin%>" dy="<%=corner_size%>"><%=suit%></tspan></text>
      <text
        text-anchor="end"
        style="font-family:'PragmataPro';font-size:<%=corner_size%>;"
        fill="<%=color%>"
        x="<%=width-margin%>" y="<%=margin%>"><tspan
          x="<%=width-margin%>" dy="<%=corner_size%>"><%=value%></tspan><tspan
          x="<%=width-margin%>" dy="<%=corner_size%>"><%=suit%></tspan></text>
      <text
        text-anchor="middle"
        style="font-family:'PragmataPro';font-size:<%=center_size%>;"
        fill="<%=color%>"
        x="<%=width/2%>" y="<%=height/2 - center_margin%>"><%=value%><%=suit%></text>
    </g>
  </defs>
  <%if debug%>
    <rect x="<%=bleed%>" y="<%=bleed%>" width="<%=width-2*bleed%>" height="<%=height-2*bleed%>" fill="none" stroke="red"/>
    <rect
      x="<%=safe%>" y="<%=safe%>"
      width="<%=width - 2*safe%>" height="<%=height - 2*safe%>"
      fill="none" stroke="red" stroke-dasharray="5,20"/>
  <%end%>
  <use xlink:href="#half"/>
  <use xlink:href="#half" transform="translate(<%=width%> <%=height%>) rotate(180)" />
</svg>
