require "minitest/autorun"
require "minitest/spec"


class A
  def whoami
    "I am A"
  end

  def other_method_in_a
    "other method in A"
  end
end

class B
  def whoami
    "I am B"
  end

  def other_method_in_b
    "other method in b"
  end

  def call_whoami
    A.new.instance_exec do
      whoami
    end
  end

  def flat_scope
    scope_of_b = "local variable in B#flat_scope"

    A.new.instance_exec do
      scope_of_b
    end
  end

  def flat_scope_but_other_self
    @scope_of_b = "member variable of B"

    A.new.instance_exec do
      @scope_of_b
    end
  end

  def call_other_method_in_a
    A.new.instance_exec do
      other_method_in_a
    end
  end

  def call_other_method_in_b
    A.new.instance_exec do
      other_method_in_b
    end
  end

  def here_be_dragons
    first_call =
      A.new.instance_exec do
        other_method_in_a
      end

    other_method_in_a = "local variable in B"

    second_call =
      A.new.instance_exec do
        other_method_in_a
      end

    [first_call, second_call]
  end
end


describe "Flat Scope" do
  let(:b) { B.new }

  describe "#call_whomai" do
    it "calls #whomai in the scope of class A" do
      b.call_whoami.must_equal "I am A"
    end
  end

  describe "#flat_scope" do
    it "has access to a local variable in the scope of B" do
      b.flat_scope.must_equal "local variable in B#flat_scope"
    end
  end

  describe "#flat_scope_but_other_self" do
    it "does not have access to member variables of B" do
      b.flat_scope_but_other_self.must_be_nil
    end
  end

  describe "#call_other_method_in_a" do
    it "can call another method of A" do
      b.call_other_method_in_a.must_equal "other method in A"
    end
  end

  describe "#call_other_method_in_b" do
    it "cannot call another method in B" do
      -> { b.call_other_method_in_b }.must_raise NameError
    end
  end

  describe "#here_be_dragons" do
    it "calls the method in the scope of A unless there is a local variable "\
       "with the same name" do
      b.here_be_dragons.must_equal ["other method in A", "local variable in B"]
    end
  end
end
