import UIKit

class CartViewController: UIViewController {
  
  @IBOutlet private var checkoutButton: UIButton!
  @IBOutlet private var totalItemsLabel: UILabel!
  @IBOutlet private var totalCostLabel: UILabel!
  
  
  //MARK: - View Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Cart"
    configureFromCart()
  }
  
  private func configureFromCart() {
    guard checkoutButton != nil else {
      //UI has not been instantiated yet. Bail!
      return
    }
    
    let cart = ShoppingCart.sharedCart
    totalItemsLabel.text = cart.itemCountString()
    
    let cost = cart.totalCost()
    totalCostLabel.text = CurrencyFormatter.dollarsFormatter.rw_string(from: cost)
    
    //Disable checkout if there's nothing to check out with
    checkoutButton.isEnabled = (cost > 0)
  }
  
  @IBAction func reset() {
    ShoppingCart.sharedCart.chocolates.value = []
    let _ = navigationController?.popViewController(animated: true)
  }
}
