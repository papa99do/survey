require File.dirname(__FILE__) + '/../test_helper'
require 'survey_controller'

# Re-raise errors caught by the controller.
class SurveyController; def rescue_action(e) raise e end; end

class SurveyControllerTest < Test::Unit::TestCase
  def setup
    @controller = SurveyController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
