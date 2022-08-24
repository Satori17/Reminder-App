//
//  NoteCell.swift
//  S.Kh_Task_25
//
//  Created by Saba Khitaridze on 24.08.22.
//

import UIKit

class NoteCell: UITableViewCell {

    //MARK: - IBOutlets
    
    @IBOutlet weak var noteTitleLabel: UILabel!
    @IBOutlet weak var noteDateLabel: UILabel!
    
    //MARK: - Cell Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - Methods
    func configure(with notes: NoteViewModel) {
        noteTitleLabel.text = notes.noteTitle
        noteDateLabel.text = notes.noteDate
    }
    
}
