#
# A class to help with outputting colored text using ANSI codes.
#
# Author:: Edward Harman (mailto:jaq@ethelred.org)

class TextColor
  def initialize(text = nil)
    @apply_to = text
    @colorings = [{}]
  end

  def text(text)
    @apply_to = text
    self
  end

  def exp(exp)
    @exp = exp
    self
  end

  def foreground(code)
    ci = code.to_i
    if (30..37).include?(ci)
        if @colorings.last.include?(:fg)
            @colorings << {}
        end
        @colorings.last[:fg] = ci
    end
    self
  end
  
  def background(code)
    ci = code.to_i
    if (40..47).include?(ci)
        if @colorings.last.include?(:bg)
            @colorings << {}
        end
        @colorings.last[:bg] = ci
    end
    self
  end
  
  def style(code) #:nodoc:
    ci = code.to_i
    if [0, 1, 4, 5, 7].include? ci
        if @colorings.last.include?(:style)
            @colorings << {}
        end
        @colorings.last[:style] = ci
    end
    self
  end
  
  def set_color(code) #:nodoc:
    if @next_bg
      background(code.to_i + 40)
    else
      foreground(code.to_i + 30)
    end
    @next_bg = false
    self
  end
  
  def on
    @next_bg = true
    self
  end
  
  def black; set_color(0); end
  def red; set_color(1); end
  def green; set_color(2); end
  def yellow; set_color(3); end
  def blue; set_color(4); end
  def magenta; set_color(5); end
  def cyan; set_color(6); end
  def white; set_color(7); end
  alias :silver :white
  alias :purple :magenta
  alias :pink :magenta
  
  def bold; style(1); end
  def underline; style(4); end
  def inverse; style(7); end
  def strike; style(9); end
  alias :invert :inverse
  alias :strikethrough :strike

  def clear
    @colorings << {:style => 0, :fg => 0, :bg => 0}
    self
  end

  def code(idx)
    if idx >= @colorings.size
        c = @colorings.last
    else
        c = @colorings[idx]
    end
    c.values.map{|n| "\033[#{n}m"}.uniq.join('')
  end

  def close
    "\033[0m"
  end

  def apply(exp = nil)
    exp = exp || @exp || /.*/
    @apply_to.gsub(exp) do |m|
        #ignore m, use last match
        matchgroups = Regexp.last_match.to_a
        if(matchgroups.size > 1)
            r = ""
            matchgroups.each_with_index do |group, idx|
                r << "#{code(idx - 1)}#{group}#{close}" if idx > 0
            end
            r
        else
            "#{code(0)}#{matchgroups[0]}#{close}"
        end
    end
  end
end

class String
  def color(tc = nil)
     tc || TextColor.new(self)
  end
end

class ColorScheme
    def initialize(*colorings)
        @colorings = colorings
    end

    def apply(text)
        t = text
        @colorings.each do |tc|
            t = tc.text(t).apply
        end
        t
    end
end
