from ._anvil_designer import Form1Template

from anvil import *
import anvil.server



class Form1(Form1Template):

  def __init__(self, **properties):

    # Set Form properties and Data Bindings.

    self.init_components(**properties)



    # Any code you write here will run before the form opens.

  def link_2_click(self, **event_args):
    """This method is called when the link is clicked"""
    pass

  def link_1_click(self, **event_args):
    """This method is called when the link is clicked"""
    pass

  def text_box_1_pressed_enter(self, **event_args):
    """This method is called when the user presses Enter in this text box"""
    pass

  def text_box_3_pressed_enter(self, **event_args):
    """This method is called when the user presses Enter in this text box"""
    pass

  def predict_button_click(self, **event_args):
    """This method is called when the button is clicked"""
    predictions = anvil.server.call('predict_impurity',
                                [self.batch_code.text,
                                self.code.text,
                                self.strength.text,
                                self.batch_size.text,
                                self.api_code.text,
                                self.api_batch.text,
                                self.smcc_batch.text,
                                self.lactose_batch.text,
                                self.starch_batch.text,
                                self.api_water.text,
                                self.api_total_impurities.text,
                                self.api_content.text,
                                self.api_ps01.text,
                                self.api_ps05.text,
                                self.api_ps09.text,
                                self.lactose_water.text,
                                self.lactose_sieve0045.text,
                                self.lactose_sieve015.text,
                                self.lactose_sieve025.text,
                                self.smcc_water.text,
                                self.smcc_td.text,
                                self.smcc_bd.text,
                                self.smcc_ps01.text,
                                self.smcc_ps05.text,
                                self.smcc_ps09.text,
                                self.starch_ph.text,
                                self.starch_water.text])
    # If a category is returned set our species 
    if predictions:
      self.prediction.visible = True
      self.prediction.text = "Dissolution Average: " + str(predictions[0]) + "%\n" + "Residual Solvent: " + str(predictions[1]) + "%\n" + "Total Impurities: " + str(predictions[2]) + "%"

  def batch_code_pressed_enter(self, **event_args):
    """This method is called when the user presses Enter in this text box"""
    pass

  def upload_button_click(self, **event_args):
    """This method is called when the button is clicked"""
    result = anvil.server.call('upload_data', 
                                [self.batch_code_upload.text,
                                self.dissolution_av.text,
                                self.residual_solvent.text,
                                self.impurities_total.text])
    # If a category is returned set our species 
    self.upload_status.visible = True
    self.upload_status.text = result