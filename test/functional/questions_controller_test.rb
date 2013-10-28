require File.dirname(__FILE__) + '/../test_helper'
require 'questions_controller'

# Re-raise errors caught by the controller.
class QuestionsController; def rescue_action(e) raise e end; end

class QuestionsControllerTest < Test::Unit::TestCase
  fixtures :questions

  def setup
    @controller = QuestionsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = questions(:first).id
  end

  def test_index
    get :index
    assert_response :success
    assert_template 'list'
  end

  def test_list
    get :list

    assert_response :success
    assert_template 'list'

    assert_not_nil assigns(:questions)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:question)
    assert assigns(:question).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:question)
  end

  def test_create
    num_questions = Question.count

    post :create, :question => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_questions + 1, Question.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:question)
    assert assigns(:question).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Question.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Question.find(@first_id)
    }
  end
end
