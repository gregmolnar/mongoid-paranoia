require "spec_helper"

describe "Paranoia uniqueness scoped validator" do
  describe "#valid?" do
    context "when the document is a root document" do
      context "when the document is paranoid" do
        before do
          ParanoidPost.validates(:title, uniqueness: { conditions: -> { where(deleted_at: nil) } })
        end

        after do
          ParanoidPost.reset_callbacks(:validate)
        end

        let!(:post) do
          ParanoidPost.create(title: "testing")
        end

        context "when the field is unique" do

          let(:new_post) do
            ParanoidPost.new(title: "test")
          end

          it "returns true" do
            new_post.should be_valid
          end
        end

        context "when the field is unique for non soft deleted docs" do

          before do
            post.delete!
          end

          let(:new_post) do
            ParanoidPost.new(title: "testing")
          end

          it "returns true" do
            new_post.should be_valid
          end
        end

        context "when the field is not unique" do

          let(:new_post) do
            ParanoidPost.new(title: "testing")
          end

          it "returns false" do
            new_post.should_not be_valid
          end
        end
      end
    end
  end
end
