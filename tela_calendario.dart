import 'package:flutter/material.dart';

import 'tarefa.dart';
import 'tela_tarefas.dart';

class TelaCalendario extends StatefulWidget {
  final String nomeUsuario;

  const TelaCalendario({
    super.key,
    required this.nomeUsuario,
  });

  @override
  State<TelaCalendario> createState() => _TelaCalendarioState();
}

class _TelaCalendarioState extends State<TelaCalendario> {
  DateTime dataSelecionada = DateTime.now();

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

  @override
  Widget build(BuildContext context) {
    final quantidadePendentes =
    ArmazenamentoTarefas.quantidadePendentes(
      dataSelecionada,
    );

    final quantidadeConcluidas =
    ArmazenamentoTarefas.quantidadeConcluidas(
      dataSelecionada,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),

      appBar: AppBar(
        backgroundColor: const Color(0xFF14213D),
        foregroundColor: Colors.white,
        title: const Text(
          'Minha Rotina',
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Olá, ${widget.nomeUsuario}!',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF14213D),
                ),
              ),

              const SizedBox(height: 5),

              const Text(
                'Escolha o dia que deseja organizar.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),

              const SizedBox(height: 24),

              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 18,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: const ColorScheme.light(
                      primary: Color(0xFF00BFA6),
                      onPrimary: Colors.white,
                      onSurface: Color(0xFF14213D),
                    ),
                  ),
                  child: CalendarDatePicker(
                    initialDate: dataSelecionada,
                    firstDate: DateTime(2024),
                    lastDate: DateTime(2035),
                    onDateChanged: (novaData) {
                      setState(() {
                        dataSelecionada = novaData;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'Dia selecionado',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF14213D),
                ),
              ),

              const SizedBox(height: 12),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF14213D),
                      Color(0xFF005F73),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.calendar_month_rounded,
                      color: Color(0xFFFFB703),
                      size: 38,
                    ),

                    const SizedBox(height: 12),

                    Text(
                      formatarData(dataSelecionada),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 7),

                    const Text(
                      'Acesse as tarefas cadastradas para esta data.',
                      style: TextStyle(
                        color: Colors.white70,
                      ),
                    ),

                    const SizedBox(height: 18),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TelaTarefas(
                                dataSelecionada: dataSelecionada,
                              ),
                            ),
                          );

                          setState(() {});
                        },
                        icon: const Icon(
                          Icons.arrow_forward_rounded,
                        ),
                        label: const Text(
                          'Ver tarefas do dia',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                          const Color(0xFFFFB703),
                          foregroundColor:
                          const Color(0xFF14213D),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              Row(
                children: [
                  Expanded(
                    child: _cardResumo(
                      titulo: 'Pendentes',
                      quantidade: quantidadePendentes,
                      icone: Icons.schedule_rounded,
                      cor: const Color(0xFFFFB703),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: _cardResumo(
                      titulo: 'Concluídas',
                      quantidade: quantidadeConcluidas,
                      icone: Icons.check_circle_outline,
                      cor: const Color(0xFF00BFA6),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cardResumo({
    required String titulo,
    required int quantidade,
    required IconData icone,
    required Color cor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 18,
        horizontal: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Icon(
            icone,
            size: 30,
            color: cor,
          ),

          const SizedBox(height: 8),

          Text(
            quantidade.toString(),
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Color(0xFF14213D),
            ),
          ),

          Text(
            titulo,
            style: const TextStyle(
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}