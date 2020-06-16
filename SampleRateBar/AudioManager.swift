//
//  AudioManager.swift
//  SampleRateBar
//

import Cocoa
import CoreAudio

class AudioManager {

    func getSampleRate() -> Float64 {
        var sampleRate:Float64 = 0
        var size:UInt32 = UInt32(MemoryLayout<Float64>.size)
        var address:AudioObjectPropertyAddress = getAdress(kAudioDevicePropertyNominalSampleRate)

        AudioObjectGetPropertyData(getCurrentAudioObjectID(), &address, 0, nil, &size, &sampleRate)

        return sampleRate;
    }

    func setSampleRate(rate: AudioValueRange) {
        var inputSampleRate:AudioValueRange = rate
        var address:AudioObjectPropertyAddress = getAdress(kAudioDevicePropertyNominalSampleRate)

        AudioObjectSetPropertyData(getCurrentAudioObjectID(), &address, 0, nil, UInt32(MemoryLayout<AudioValueRange>.size), &inputSampleRate)
    }

    func getAvailableSampleRates() -> [AudioValueRange] {
        let id = getCurrentAudioObjectID()
        var address:AudioObjectPropertyAddress = getAdress(kAudioDevicePropertyAvailableNominalSampleRates)

        var dataSize:UInt32 = 0
        AudioObjectGetPropertyDataSize(id, &address, 0, nil, &dataSize)

        let valueCount:UInt32 = dataSize / UInt32(MemoryLayout<AudioValueRange>.size)

        var values:[AudioValueRange] = Array<AudioValueRange>(repeating: AudioValueRange(), count: Int(valueCount))

        AudioObjectGetPropertyData(id, &address, 0, nil, &dataSize, &values)

        return values
    }

    func getCurrentAudioObjectID() -> AudioObjectID {
        var size:UInt32 = UInt32(MemoryLayout<AudioObjectID>.size)
        var deviceID:AudioObjectID = kAudioDeviceUnknown
        var address:AudioObjectPropertyAddress = getAdress(kAudioHardwarePropertyDefaultOutputDevice)

        AudioObjectGetPropertyData(AudioObjectID(kAudioObjectSystemObject), &address, 0, nil, &size, &deviceID);

        return deviceID;
    }

    func getAdress(_ selector:AudioObjectPropertySelector) -> AudioObjectPropertyAddress {
        var address:AudioObjectPropertyAddress = AudioObjectPropertyAddress()
        address.mSelector = selector
        address.mScope = kAudioObjectPropertyScopeGlobal
        address.mElement = kAudioObjectPropertyElementMaster

        return address
    }
}
