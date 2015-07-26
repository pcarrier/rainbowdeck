#!/usr/bin/env ruby
# coding: utf-8

require 'erb'

SUITS = {
  '♠' => '#006064',
  '♥' => '#B71C1C',
  '♣' => '#1B5E20',
  '♦' => '#01579B',
  '★' => '#F57F17',
  'Ψ' => '#4A148C',
}

class Card
  def binding_
    binding
  end

  def suits
    SUITS
  end

  def factor; 3; end
  def height; 1122 * factor; end
  def bleed; 36 * factor; end
  def safe; bleed + (36 * factor); end
  def width; 822 * factor; end
  def tsize; 150 * factor; end
  def radius; 600 * factor; end
  def downscale; 0.9; end
  def steps; 90; end
  def debug; ENV['DEBUG']; end
end
TEMPLATE = ERB.new DATA.read

File.open 'back4.svg', 'w' do |f|
  f.write TEMPLATE.result Card.new.binding_
end

__END__
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"
     version="1.1" width="<%=width%>" height="<%=height%>" viewBox="0 0 <%=width%> <%=height%>">
  <defs>
    <g id="chunk">
      <% suits.each_with_index do |s, i| %>
        <text
          text-anchor="middle"
          style="font-family:PragmataPro;font-size:<%=tsize%>;"
          fill="<%=s[1]%>"
          transform="
            rotate(<%=i*90/suits.size%>)
            translate(0 -<%=radius%>)
          "><%=s.first%></text>
      <% end %>
    </g>
    <g id="circle">
      <use xlink:href="#chunk"/>
      <use xlink:href="#chunk" transform="rotate(90)"/>
      <use xlink:href="#chunk" transform="rotate(180)"/>
      <use xlink:href="#chunk" transform="rotate(270)"/>
    </g>
  </defs>
  <rect x="0" y="0" width="<%=width%>" height="<%=height%>" fill="black"/>
  <g transform="translate(<%=width/2%> <%=height/2%>)">
    <% steps.times do |step| %>
      <use xlink:href="#circle" transform="scale(<%=downscale**step%>) rotate(<%=45/suits.size * step % 90%>)"/>
    <% end %>
  </g>
  <%if debug%>
    <rect x="<%=bleed%>" y="<%=bleed%>" width="<%=width-2*bleed%>" height="<%=height-2*bleed%>" fill="none" stroke="red"/>
    <rect
      x="<%=safe%>" y="<%=safe%>"
      width="<%=width - 2*safe%>" height="<%=height - 2*safe%>"
      fill="none" stroke="red" stroke-dasharray="5,20"/>
  <%end%>
</svg>
