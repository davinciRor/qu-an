require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create :question, user: user }
  let(:user) { create(:user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2, user: user) }
    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'render index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, id: question }

    it 'assigns the request question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'render show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    sign_in_user

    before { get :new, user_id: @user }

    it 'assign new question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'render new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    sign_in_user

    let(:my_question) { create(:question, user: @user) }

    before { get :edit, id: my_question }

    it 'assigns the request question to @question' do
      expect(assigns(:question)).to eq my_question
    end

    it 'render edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      it 'save new question in db' do
        expect { post :create, question: attributes_for(:question, user: @user) }.to change(@user.questions, :count).by(1)
      end

      it 'redirect to show view' do
        post :create, question: attributes_for(:question)
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it 'don`t save question in db' do
        expect { post :create, question: attributes_for(:invalid_question, user: @user) }.to_not change(@user.questions, :count)
      end

      it 're-render new view' do
        post :create, question: attributes_for(:invalid_question, user: @user)
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    sign_in_user

    let(:my_question) { create(:question, user: @user) }

    context 'with valid attributes' do
      it 'assigns the requested question to @question' do
        patch :update, id: my_question, question: attributes_for(:question)
        expect(assigns(:question)).to eq my_question
      end

      it 'change question attributes' do
        patch :update, id: my_question, question: { title: 'new_title', body: 'new_body' }
        my_question.reload
        expect(my_question.title).to eq 'new_title'
        expect(my_question.body).to eq 'new_body'
      end

      it 'redirect to show view' do
        patch :update, id: my_question, question: attributes_for(:question)
        expect(response).to redirect_to my_question
      end
    end

    context 'with invalid attributes' do
      before { patch :update, id: my_question, question: { title: 'new_title', body: nil } }

      it 'does not change attributes' do
        my_question.reload
        expect(my_question.title).to eq 'MyTitle'
        expect(my_question.body).to eq 'MyText'
      end

      it 're-render edit view' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user

    let!(:my_question) { create(:question, user: @user) }

    it 'delete question' do
      expect { delete :destroy, id: my_question }.to change(Question, :count).by(-1)
    end

    it 'redirect to index view' do
      delete :destroy, id: my_question
      expect(response).to redirect_to questions_path
    end
  end
end
