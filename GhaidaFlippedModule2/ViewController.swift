//
//  ViewController.swift
//  GhaidaFlippedModule2
//
//  Created by Ghaida Atoum on 9/29/24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var userView: UIView!
    struct AudioConstants{
        static let AUDIO_BUFFER_SIZE = 1024*4
        static let NUM_EQUALIZER_POINTS = 20
    }
    
    // setup audio model
    let audio = AudioModel(buffer_size: AudioConstants.AUDIO_BUFFER_SIZE, equalizer_size: AudioConstants.NUM_EQUALIZER_POINTS)
    lazy var graph:MetalGraph? = {
        return MetalGraph(userView: self.userView)
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGraph()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.audio.play()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.audio.stop()
    }
    
    // periodically, update the graph with refreshed FFT Data
    func updateGraph(){
        
        if let graph = self.graph{
            graph.updateGraph(
                data: self.audio.timeData,
                forKey: "time"
            )
            
            graph.updateGraph(
                data: self.audio.fftData,
                forKey: "fft"
            )
            
            graph.updateGraph(
                data: self.audio.maxFftData,
                forKey: "fftMax"
            )
            
        }
        
    }
    
    func setupGraph() {
        if let graph = self.graph{
            graph.setBackgroundColor(r: 0, g: 0, b: 0, a: 1)
            
            // add in graphs for display
            // note that we need to normalize the scale of this graph
            // because the fft is returned in dB which has very large negative values and some large positive values

            graph.addGraph(withName: "time",
                           numPointsInGraph: AudioConstants.AUDIO_BUFFER_SIZE)

            graph.addGraph(withName: "fft",
                           shouldNormalizeForFFT: true,
                           numPointsInGraph: AudioConstants.AUDIO_BUFFER_SIZE/2)
            
            graph.addGraph(withName: "fftMax",
                           shouldNormalizeForFFT: true,
                           numPointsInGraph: AudioConstants.NUM_EQUALIZER_POINTS)
        
            graph.makeGrids() // add grids to graph
        }
        
        // start up the audio model here, querying microphone
        // audio.startMicrophoneProcessing(withFps: 20) // preferred number of FFT calculations per second
        audio.startProcesingAudioFileForPlayback(withFps: 20)
        
        audio.togglePlaying()
        
        // run the loop for updating the graph peridocially
        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
            self.updateGraph()
        }
    }

}


