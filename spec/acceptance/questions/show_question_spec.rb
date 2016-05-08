require 'rails_helper'

feature 'Look through question', %q{
  In order to find answer for some question
  As an user
  I want to be able to see question and answers for it
} do

  given(:user)      { create(:user) }
  given(:question)  { create(:question, user: user) }
  given!(:answer)   { create_list(:answer, 5, question: question, user: user) }

  scenario 'User see question and answers for it' do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(all('.answer').count).to eq 5
  end
end
