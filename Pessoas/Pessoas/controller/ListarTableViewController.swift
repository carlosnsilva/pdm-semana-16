//
//  ListarTableViewController.swift
//  Pessoas
//
//  Created by Valéria Cavalcanti on 25/05/21.
//

import UIKit

class ListarTableViewController: UITableViewController {
    var lista: Array<Pessoa>!
    
    @IBAction func mostraPopup(_ sender: Any){
        var busca = UIAlertController(title: "Filtro", message: "Filtrar pelo nome da pessoa", preferredStyle: UIAlertController.Style.alert)
        busca.addTextField {
            textField in textField.placeholder = "Digite um nome que deseja buscar"
        }
        
        busca.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {
            alertAction in var buscaNome = busca.textField![0].text!
            
            if(buscaNome != nil){
                self.lista = PessoaDAO().getPorNome(nome: buscaNome)
                self.tableView.reloadData()
            }
        }))
        
        busca.addAction(UIAlertAction(title: "Cancelar", style: UIAlertAction.Style.default, handler: nil))
        
        busca.addAction(UIAlertAction(title: "Exibir Todas", style: UIAlertAction.Style.cancel, handler: {alertAction in self.lista = PessoaDao.get()
            self.tableView.reloadData()
        }))
        
        self.present(busca, animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lista = PessoaDAO().get()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.lista = PessoaDAO().get()
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.lista.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pessoa", for: indexPath)

        let pessoa = self.lista[indexPath.row]
        
        cell.textLabel?.text = pessoa.nome
        cell.detailTextLabel?.text = String(pessoa.idade)

        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let pessoa = self.lista[indexPath.row]
            PessoaDAO().del(pessoa: pessoa)
            self.lista.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let fvc = self.storyboard?.instantiateViewController(identifier: "formulario") as! FormViewController
        fvc.pessoaEditavel = self.lista[indexPath.row]
        self.navigationController?.pushViewController(fvc, animated: true)
    }

}
