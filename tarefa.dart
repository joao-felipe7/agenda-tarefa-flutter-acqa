class Tarefa {
  final String id;
  final String titulo;
  bool concluida;

  Tarefa({
    required this.id,
    required this.titulo,
    this.concluida = false,
  });
}

class ArmazenamentoTarefas {
  static final Map<String, List<Tarefa>> _tarefasPorData = {};

  static String _chaveData(DateTime data) {
    return '${data.year}-'
        '${data.month.toString().padLeft(2, '0')}-'
        '${data.day.toString().padLeft(2, '0')}';
  }

  static List<Tarefa> obterTarefas(DateTime data) {
    final chave = _chaveData(data);

    final tarefas = List<Tarefa>.from(
      _tarefasPorData[chave] ?? [],
    );

    tarefas.sort((tarefaA, tarefaB) {
      // Pendentes aparecem antes das concluídas.
      if (tarefaA.concluida != tarefaB.concluida) {
        return tarefaA.concluida ? 1 : -1;
      }

      // Dentro de cada grupo, ordem alfabética.
      return tarefaA.titulo
          .toLowerCase()
          .compareTo(tarefaB.titulo.toLowerCase());
    });

    return tarefas;
  }

  static void adicionarTarefa(
      DateTime data,
      String titulo,
      ) {
    final chave = _chaveData(data);

    _tarefasPorData.putIfAbsent(
      chave,
          () => [],
    );

    _tarefasPorData[chave]!.add(
      Tarefa(
        id: DateTime.now()
            .microsecondsSinceEpoch
            .toString(),
        titulo: titulo,
      ),
    );
  }

  static void alterarStatus(
      DateTime data,
      String id,
      ) {
    final chave = _chaveData(data);

    final tarefas = _tarefasPorData[chave];

    if (tarefas == null) {
      return;
    }

    final tarefa = tarefas.firstWhere(
          (tarefa) => tarefa.id == id,
    );

    tarefa.concluida = !tarefa.concluida;
  }

  static void removerTarefa(
      DateTime data,
      String id,
      ) {
    final chave = _chaveData(data);

    _tarefasPorData[chave]?.removeWhere(
          (tarefa) => tarefa.id == id,
    );
  }

  static int quantidadePendentes(DateTime data) {
    return obterTarefas(data)
        .where(
          (tarefa) => !tarefa.concluida,
    )
        .length;
  }

  static int quantidadeConcluidas(DateTime data) {
    return obterTarefas(data)
        .where(
          (tarefa) => tarefa.concluida,
    )
        .length;
  }
}