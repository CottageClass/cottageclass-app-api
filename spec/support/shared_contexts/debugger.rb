shared_context "debugger" do
  after(:each) do |ex|
    if ex.exception
      byebug
    end
  end
end
