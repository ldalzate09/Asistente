//
//  PieChartViewController.swift
//  Asistente
//
//  Created by Yefry Alexis Calderon Yepes on 18/10/18.
//  Copyright © 2018 Leydy Alzate. All rights reserved.
//

import UIKit
import Charts
import AVFoundation

class PieChartViewController: DemoBaseViewController {

    @IBOutlet weak var chartView: PieChartView!
    @IBOutlet weak var balanceButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let balance = BankAccount.checkBalance() else { return }
        balanceButton.setTitle("Account Balance: $\(balance)", for: .normal) 
        
        // Do any additional setup after loading the view.
        self.title = "Pie Chart"
        
        self.options = [.toggleValues,
                        .toggleXValues,
                        .togglePercent,
                        .toggleHole,
                        .toggleIcons,
                        .animateX,
                        .animateY,
                        .animateXY,
                        .spin,
                        .drawCenter,
                        .saveToGallery,
                        .toggleData]
        
        self.setup(pieChartView: chartView)
        
        chartView.delegate = self
        
        let l = chartView.legend
        l.horizontalAlignment = .right
        l.verticalAlignment = .top
        l.orientation = .vertical
        l.xEntrySpace = 7
        l.yEntrySpace = 0
        l.yOffset = 0
        //        chartView.legend = l
        
        self.balanceButton.layer.cornerRadius = 5
        self.balanceButton.clipsToBounds = true
        
        // entry label styling
        chartView.entryLabelColor = .white
        chartView.entryLabelFont = .systemFont(ofSize: 12, weight: .light)
        
        //sliderX.value = 4
        //sliderY.value = 100
        //self.slidersValueChanged(nil)
        self.updateChartData()
        chartView.animate(xAxisDuration: 1.4, easingOption: .easeOutBack)
    }
    
    override func updateChartData() {
        if self.shouldHideData {
            chartView.data = nil
            return
        }
        
        self.setDataCount(Int(4), range: UInt32(100))
    }
    
    func setDataCount(_ count: Int, range: UInt32) {
        let entries = (0..<count).map { (i) -> PieChartDataEntry in
            // IMPORTANT: In a PieChart, no values (Entry) should have the same xIndex (even if from different DataSets), since no values can be drawn above each other.
            return PieChartDataEntry(value: Double(arc4random_uniform(range) + range / 5),
                                     label: parties[i % parties.count],
                                     icon: #imageLiteral(resourceName: "icon"))
        }
        
        let set = PieChartDataSet(values: entries, label: "Election Results")
        set.drawIconsEnabled = false
        set.sliceSpace = 2
        
        
        set.colors = ChartColorTemplates.vordiplom()
            + ChartColorTemplates.joyful()
            + ChartColorTemplates.colorful()
            + ChartColorTemplates.liberty()
            + ChartColorTemplates.pastel()
            + [UIColor (red: 45/255, green: 45/255, blue: 250/255, alpha: 1)]
            //+ [UIColor (red: 51/255, green: 181/255, blue: 229/255, alpha: 1)]
        
        let data = PieChartData(dataSet: set)
        
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1
        pFormatter.percentSymbol = " %"
        data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
        
        data.setValueFont(.systemFont(ofSize: 9, weight: .light))
        data.setValueTextColor(.black)
        
        chartView.data = data
        chartView.highlightValues(nil)
    }
    
    override func optionTapped(_ option: Option) {
        switch option {
        case .toggleXValues:
            chartView.drawEntryLabelsEnabled = !chartView.drawEntryLabelsEnabled
            chartView.setNeedsDisplay()
            
        case .togglePercent:
            chartView.usePercentValuesEnabled = !chartView.usePercentValuesEnabled
            chartView.setNeedsDisplay()
            
        case .toggleHole:
            chartView.drawHoleEnabled = !chartView.drawHoleEnabled
            chartView.setNeedsDisplay()
            
        case .drawCenter:
            chartView.drawCenterTextEnabled = !chartView.drawCenterTextEnabled
            chartView.setNeedsDisplay()
            
        case .animateX:
            chartView.animate(xAxisDuration: 1.4)
            
        case .animateY:
            chartView.animate(yAxisDuration: 1.4)
            
        case .animateXY:
            chartView.animate(xAxisDuration: 1.4, yAxisDuration: 1.4)
            
        case .spin:
            chartView.spin(duration: 2,
                           fromAngle: chartView.rotationAngle,
                           toAngle: chartView.rotationAngle + 360,
                           easingOption: .easeInCubic)
            
        default:
            handleOption(option, forChartView: chartView)
        }
    }
    
    // MARK: - Actions
    @IBAction func slidersValueChanged(_ sender: Any?) {
        //sliderTextX.text = "\(Int(sliderX.value))"
        //sliderTextY.text = "\(Int(sliderY.value))"
        
        self.updateChartData()
    }
    
    @IBAction func showPreAprob(_ sender: Any) {
        
        let alert = UIAlertController(title: "Pre Aprobado", message: "Tienen un pre aprobado por $6'000.000", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertAction.Style.default, handler: { action in
            BankAccount.deposit(amount: 6000000)
            self.setDataCount(Int(5), range: UInt32(100))
            guard let balance = BankAccount.checkBalance() else { return }
            self.balanceButton.setTitle("Account Balance: $\(balance)", for: .normal) 
        }))
        alert.addAction(UIAlertAction(title: "Cancelar", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        let string = "Tienes un pre aprobado por seis millones de pesos, ¿Deseas tomarlo?"
        let utterance = AVSpeechUtterance(string: string)
        utterance.voice = AVSpeechSynthesisVoice(language: "es-LA")
        
        let synth = AVSpeechSynthesizer()
        synth.speak(utterance)
    }
    
    @IBAction func cancelViewController(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
