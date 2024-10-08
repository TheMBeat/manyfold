require "rails_helper"

RSpec.describe Comment do
  let!(:model) { create(:model) }
  let!(:comment) { create(:comment, commenter: model, commentable: model) }

  it "posts a Federails Activity on creation" do # rubocop:disable RSpec/MultipleExpectations
    expect { create(:comment, commenter: model, commentable: model) }.to change(Federails::Activity, :count).by(1)
    expect(Federails::Activity.last.action).to eq "Create"
  end

  it "posts a Federails Activity on update" do # rubocop:disable RSpec/MultipleExpectations
    expect { comment.update(comment: "test") }.to change(Federails::Activity, :count).by(1)
    expect(Federails::Activity.last.action).to eq "Update"
  end

  it "posts a Federails Activity on deletion" do # rubocop:disable RSpec/MultipleExpectations
    expect { comment.destroy }.to change(Federails::Activity, :count).by(1)
    expect(Federails::Activity.last.action).to eq "Delete"
  end

  it "has a federated_url method" do
    expect(comment.federated_url).to eq "http://localhost:3214/models/#{model.public_id}/comments/#{comment.public_id}"
  end
end
