import 'package:flutter/material.dart';

import 'tarefa.dart';


class TelaTarefas extends StatefulWidget {
  final DateTime dataSelecionada;

  const TelaTarefas({
    super.key,
    required this.dataSelecionada,
  });

  @override
  State<TelaTarefas> createState() => _TelaTarefasState();
}

class _TelaTarefasState extends State<TelaTarefas> {
  final List<String> meses = [
    'Janeiro',
    'Fevereiro',
    'Março',
    'Abril',
    'Maio',
    'Junho',
    'Julho',
    'Agosto',
    'Setembro',
    'Outubro',
    'Novembro',
    'Dezembro',
  ];

  String formatarData(DateTime data) {
    return '${data.day} de ${meses[data.month - 1]} de ${data.year}';
  }

  Future<void> abrirDialogoAdicionar() async {
    String textoTarefa = '';

    final String? novaTarefa = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Row(
            children: [
              Icon(
                Icons.add_task_rounded,
                color: Color(0xFF00BFA6),
              ),
              SizedBox(width: 10),
              Text('Nova tarefa'),
            ],
          ),
          content: TextField(
            autofocus: true,
            textCapitalization: TextCapitalization.sentences,

            onChanged: (valor) {
              textoTarefa = valor;
            },

            decoration: InputDecoration(
              labelText: 'Nome da tarefa',
              hintText: 'Ex.: Estudar Flutter',
              prefixIcon: const Icon(
                Icons.edit_note_rounded,
              ),
              filled: true,
              fillColor: const Color(0xFFF4F6F8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Cancelar',
              ),
            ),

            ElevatedButton(
              onPressed: () {
                final texto = textoTarefa.trim();

                if (texto.isNotEmpty) {
                  Navigator.pop(
                    context,
                    texto,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00BFA6),
                foregroundColor: Colors.white,
              ),
              child: const Text(
                'Adicionar',
              ),
            ),
          ],
        );
      },
    );

    if (!mounted) {
      return;
    }

    if (novaTarefa != null &&
        novaTarefa.trim().isNotEmpty) {
      setState(() {
        ArmazenamentoTarefas.adicionarTarefa(
          widget.dataSelecionada,
          novaTarefa.trim(),
        );
      });
    }
  }

  Future<void> removerTarefa(Tarefa tarefa) async {
    final bool? confirmar = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Colors.redAccent,
              ),
              SizedBox(width: 10),
              Text('Excluir tarefa'),
            ],
          ),
          content: Text(
            'Deseja realmente excluir a tarefa "${tarefa.titulo}"?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  false,
                );
              },
              child: const Text(
                'Cancelar',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  true,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
              ),
              child: const Text(
                'Excluir',
              ),
            ),
          ],
        );
      },
    );

    if (!mounted) {
      return;
    }

    if (confirmar != true) {
      return;
    }

    setState(() {
      ArmazenamentoTarefas.removerTarefa(
        widget.dataSelecionada,
        tarefa.id,
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Tarefa "${tarefa.titulo}" removida.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tarefas =
    ArmazenamentoTarefas.obterTarefas(
      widget.dataSelecionada,
    );

    final pendentes =
    ArmazenamentoTarefas.quantidadePendentes(
      widget.dataSelecionada,
    );

    final concluidas =
    ArmazenamentoTarefas.quantidadeConcluidas(
      widget.dataSelecionada,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),

      appBar: AppBar(
        backgroundColor: const Color(0xFF14213D),
        foregroundColor: Colors.white,
        title: const Text(
          'Tarefas do dia',
        ),
      ),

      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(
              22,
              22,
              22,
              24,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF14213D),
                  Color(0xFF005F73),
                ],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
            ),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                const Text(
                  'Planejamento',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  formatarData(
                    widget.dataSelecionada,
                  ),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    _indicador(
                      icone: Icons.schedule_rounded,
                      texto: '$pendentes pendente(s)',
                      cor: const Color(0xFFFFB703),
                    ),

                    const SizedBox(width: 18),

                    _indicador(
                      icone:
                      Icons.check_circle_outline,
                      texto: '$concluidas concluída(s)',
                      cor: const Color(0xFF00D6B8),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            child: tarefas.isEmpty
                ? _estadoVazio()
                : ListView.builder(
              padding: const EdgeInsets.fromLTRB(
                20,
                20,
                20,
                100,
              ),
              itemCount: tarefas.length,
              itemBuilder: (context, index) {
                final tarefa =
                tarefas[index];

                return _cardTarefa(
                  tarefa,
                );
              },
            ),
          ),
        ],
      ),

      floatingActionButton:
      FloatingActionButton.extended(
        onPressed: abrirDialogoAdicionar,
        backgroundColor: const Color(0xFFFFB703),
        foregroundColor: const Color(0xFF14213D),
        icon: const Icon(
          Icons.add_rounded,
        ),
        label: const Text(
          'Nova tarefa',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _indicador({
    required IconData icone,
    required String texto,
    required Color cor,
  }) {
    return Row(
      children: [
        Icon(
          icone,
          size: 18,
          color: cor,
        ),
        const SizedBox(width: 5),
        Text(
          texto,
          style: TextStyle(
            color: cor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _cardTarefa(Tarefa tarefa) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 7,
        ),

        leading: Checkbox(
          value: tarefa.concluida,
          activeColor: const Color(0xFF00BFA6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          onChanged: (valor) {
            setState(() {
              ArmazenamentoTarefas.alterarStatus(
                widget.dataSelecionada,
                tarefa.id,
              );
            });
          },
        ),

        title: Text(
          tarefa.titulo,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: tarefa.concluida
                ? Colors.black45
                : const Color(0xFF14213D),
            decoration: tarefa.concluida
                ? TextDecoration.lineThrough
                : null,
          ),
        ),

        subtitle: Text(
          tarefa.concluida
              ? 'Concluída'
              : 'Pendente',
          style: TextStyle(
            color: tarefa.concluida
                ? const Color(0xFF00A991)
                : const Color(0xFFD59200),
          ),
        ),

        trailing: IconButton(
          tooltip: 'Excluir tarefa',
          onPressed: () {
            removerTarefa(tarefa);
          },
          icon: const Icon(
            Icons.delete_outline_rounded,
            color: Colors.redAccent,
          ),
        ),
      ),
    );
  }

  Widget _estadoVazio() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: const BoxDecoration(
                color: Color(0xFFDDF8F3),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.task_alt_rounded,
                size: 54,
                color: Color(0xFF00BFA6),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Nenhuma tarefa neste dia',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF14213D),
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Toque em "Nova tarefa" para começar a organizar sua rotina.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}