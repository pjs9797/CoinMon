import UIKit

extension UITableView {
    func goToMiddle() {
        DispatchQueue.main.async {
            let row = self.numberOfRows(inSection: 0) - 1
            
            let indexPath = IndexPath(row: row/2-3, section: 0)
            self.scrollToRow(at: indexPath, at: .bottom, animated: false)
        }
    }
}
