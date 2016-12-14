import UIKit
import RxSwift
import RxCocoa

class ChocolatesOfTheWorldViewController: UIViewController {
  
  @IBOutlet private var cartButton: UIBarButtonItem!
  @IBOutlet private var tableView: UITableView!
  
  
  /*
      Isso cria um DisposeBag que você usará para garantir que os Observadores que você configurou serão limpos quando deinit () for chamado.
   
 */
  let disposeBag = DisposeBag()
  
  
  /*
   
   Just , sabe que o valor nao sofre reacoes(alteracoes).
   Mas isso é um exagero, se ele nao muda, pq projetar a variavel reagir a mudanca ?
   Pode deixar normal.
   
 */
  let europeanChocolates = Observable.just(Chocolate.ofEurope)

  
  //MARK: View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Chocolate!!!"

    setupCartObserver()
    setupCellConfiguration()
    setupCellTapHandling()

  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  
  
  
  //MARK: Rx Setup
  
  
  /*
   1 -- Adiciona no obervable chocolate carrinhos como observable
   2 -- O parâmetro de entrada para o encerramento é o novo valor do seu Observável(Observable) e você continuará recebendo essas notificações até que você cancele a assinatura ou sua assinatura seja descartada. O que você recebe de volta deste método é um observador de acordo com Disposable.
   3 -- Você adiciona o Observer da etapa anterior ao seu DispositionBag para garantir que sua assinatura é descartada quando o objeto de inscrição (Observable) é desalocado.

   */
  
  private func setupCartObserver() {
    //1
    ShoppingCart.sharedCart.chocolates.asObservable()
      .subscribe(onNext: { //2
        chocolates in
        self.cartButton.title = "\(chocolates.count) 🍫"
      })
      .addDisposableTo(disposeBag) //3
  }
  
  
  
  
  
  private func setupCellConfiguration() {
    //1
    europeanChocolates
      .bindTo(tableView
        .rx //2
        .items(cellIdentifier: ChocolateCell.Identifier,
               cellType: ChocolateCell.self)) { // 3
                row, chocolate, cell in
                cell.configureWithChocolate(chocolate: chocolate) //4
      }
      .addDisposableTo(disposeBag) //5
  }
  
  private func setupCellTapHandling() {
    tableView
      .rx
      .modelSelected(Chocolate.self) //1
      .subscribe(onNext: { //2
        chocolate in
        ShoppingCart.sharedCart.chocolates.value.append(chocolate) //3
        
        if let selectedRowIndexPath = self.tableView.indexPathForSelectedRow {
          self.tableView.deselectRow(at: selectedRowIndexPath, animated: true)
        } //4
      })
      .addDisposableTo(disposeBag) //5
  }
  
}


// MARK: - SegueHandler
extension ChocolatesOfTheWorldViewController: SegueHandler {
  
  enum SegueIdentifier: String {
    case
    GoToCart
  }
}
