// Activity 3 Network Diagnostic
//
// Represents the current stage of the network diagnostic process.

enum NetworkTestStage {
  idle,
  measuringIdlePing,
  measuringDownload,
  measuringUpload,
  completed,
  failed, //activity 3 extintion 
}