class FAQModel {
  final dynamic docid;
  final dynamic answer;
  final dynamic question;
  final bool deactivate;
  final dynamic time;
  FAQModel(
      {required this.deactivate,
        this.docid,
        this.time,
        required this.answer,
        required this.question});

  Map<String, dynamic> toMap() {
    return {
      'answer': answer,
      'question': question,
      'docid': docid,
      'deactivate': deactivate,
      'time': time,
    };
  }

  factory FAQModel.fromMap(Map<String, dynamic> map) {
    return FAQModel(
      question: map['question'],
      answer: map['answer'],
      deactivate: map['deactivate'],
      docid: map['docid'],
      time: map['time'],
    );
  }
}
