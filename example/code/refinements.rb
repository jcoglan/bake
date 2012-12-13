module Foo
  refine String do
    def wtf ; :wtf ; end
  end
  def self.hello
    p (class << 'string' ; self ; end).ancestors
    p "string".method(:wtf)
    p "string".wtf
  end
end
 
Foo.hello
 
# [String, Comparable, Object, Kernel, BasicObject]
# #<Method: String(#<Module:0x00000001061bd8>)#wtf>
# :wtf

