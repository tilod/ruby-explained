require 'minitest/autorun'
require 'minitest/spec'
 

class A
  def whoami
    'I am A'
  end
 
  def closure
    ->{ whoami }
  end
end
 

class B
  def whoami
    'I am B'
  end

  def call_closure_directly
    A.new.closure.call
  end

  def call_closure_with_instance_exec
    instance_exec &(A.new.closure)
  end

  define_method :call_closure_defined_as_method, A.new.closure
end


describe 'Closures' do
  let(:b) { B.new }

  describe '#call_closure_directly' do
    it 'preserved the scope of A' do
      b.call_closure_directly.must_equal 'I am A'
    end
  end

  describe '#call_closure_with_instance_exec' do
    it 'is executed in the scope of B' do
      b.call_closure_with_instance_exec.must_equal 'I am B'
    end
  end

  describe '#call_closure_defined_as_method' do
    it 'is executed in the scope of B' do
      b.call_closure_defined_as_method.must_equal 'I am B'
    end
  end
end
