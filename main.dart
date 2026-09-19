import 'package:flutter/material.dart';
import 'tela_calendario.dart';

void main() {
  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Minha Rotina',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00BFA6),
        ),
      ),
      home: const TelaLogin(),
    );
  }
}

class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key});

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nomeController =
  TextEditingController();

  final TextEditingController emailController =
  TextEditingController();

  final TextEditingController senhaController =
  TextEditingController();

  final TextEditingController confirmarSenhaController =
  TextEditingController();

  bool modoLogin = true;

  bool esconderSenha = true;
  bool esconderConfirmarSenha = true;

  // Dados utilizados para simular um cadastro.
  String? nomeCadastrado;
  String? emailCadastrado;
  String? senhaCadastrada;

  @override
  void dispose() {
    nomeController.dispose();
    emailController.dispose();
    senhaController.dispose();
    confirmarSenhaController.dispose();

    super.dispose();
  }

  void alternarModo() {
    setState(() {
      modoLogin = !modoLogin;

      nomeController.clear();
      senhaController.clear();
      confirmarSenhaController.clear();
    });
  }

  void enviarFormulario() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // LOGIN
    if (modoLogin) {
      if (emailCadastrado == null || senhaCadastrada == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Você precisa realizar um cadastro primeiro.',
            ),
          ),
        );

        return;
      }

      if (emailController.text.trim() != emailCadastrado ||
          senhaController.text != senhaCadastrada) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'E-mail ou senha incorretos.',
            ),
          ),
        );

        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Login realizado! Bem-vindo, $nomeCadastrado.',
          ),
          backgroundColor: const Color(0xFF00BFA6),
        ),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TelaCalendario(
            nomeUsuario: nomeCadastrado!,
          ),
        ),
      );
    }

    // CADASTRO
    else {
      nomeCadastrado = nomeController.text.trim();
      emailCadastrado = emailController.text.trim();
      senhaCadastrada = senhaController.text;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Cadastro realizado com sucesso!',
          ),
          backgroundColor: Color(0xFF00BFA6),
        ),
      );

      setState(() {
        modoLogin = true;

        nomeController.clear();
        senhaController.clear();
        confirmarSenhaController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF14213D),
              Color(0xFF005F73),
              Color(0xFF00BFA6),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 430,
                ),
                child: Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 20,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.stretch,
                      children: [
                        const Icon(
                          Icons.task_alt_rounded,
                          size: 65,
                          color: Color(0xFF00BFA6),
                        ),

                        const SizedBox(height: 14),

                        Text(
                          modoLogin
                              ? 'Minha Rotina'
                              : 'Criar Conta',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF14213D),
                          ),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          modoLogin
                              ? 'Organize suas tarefas e mantenha o foco.'
                              : 'Cadastre-se para começar a organizar sua rotina.',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.black54,
                          ),
                        ),

                        const SizedBox(height: 26),

                        if (!modoLogin) ...[
                          TextFormField(
                            controller: nomeController,
                            decoration: campoDecoracao(
                              texto: 'Nome',
                              icone: Icons.person_outline,
                            ),
                            validator: (valor) {
                              if (valor == null ||
                                  valor.trim().isEmpty) {
                                return 'Digite seu nome.';
                              }

                              return null;
                            },
                          ),

                          const SizedBox(height: 14),
                        ],

                        TextFormField(
                          controller: emailController,
                          keyboardType:
                          TextInputType.emailAddress,
                          decoration: campoDecoracao(
                            texto: 'E-mail',
                            icone: Icons.email_outlined,
                          ),
                          validator: (valor) {
                            if (valor == null ||
                                valor.trim().isEmpty) {
                              return 'Digite seu e-mail.';
                            }

                            if (!valor.contains('@') ||
                                !valor.contains('.')) {
                              return 'Digite um e-mail válido.';
                            }

                            return null;
                          },
                        ),

                        const SizedBox(height: 14),

                        TextFormField(
                          controller: senhaController,
                          obscureText: esconderSenha,
                          decoration: campoDecoracao(
                            texto: 'Senha',
                            icone: Icons.lock_outline,
                            botaoFinal: IconButton(
                              onPressed: () {
                                setState(() {
                                  esconderSenha =
                                  !esconderSenha;
                                });
                              },
                              icon: Icon(
                                esconderSenha
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                            ),
                          ),
                          validator: (valor) {
                            if (valor == null ||
                                valor.isEmpty) {
                              return 'Digite sua senha.';
                            }

                            if (valor.length < 4) {
                              return 'A senha deve possuir pelo menos 4 caracteres.';
                            }

                            return null;
                          },
                        ),

                        if (!modoLogin) ...[
                          const SizedBox(height: 14),

                          TextFormField(
                            controller:
                            confirmarSenhaController,
                            obscureText:
                            esconderConfirmarSenha,
                            decoration: campoDecoracao(
                              texto: 'Confirmar senha',
                              icone: Icons.lock_reset,
                              botaoFinal: IconButton(
                                onPressed: () {
                                  setState(() {
                                    esconderConfirmarSenha =
                                    !esconderConfirmarSenha;
                                  });
                                },
                                icon: Icon(
                                  esconderConfirmarSenha
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                ),
                              ),
                            ),
                            validator: (valor) {
                              if (valor == null ||
                                  valor.isEmpty) {
                                return 'Confirme sua senha.';
                              }

                              if (valor !=
                                  senhaController.text) {
                                return 'As senhas não são iguais.';
                              }

                              return null;
                            },
                          ),
                        ],

                        const SizedBox(height: 24),

                        SizedBox(
                          height: 52,
                          child: ElevatedButton(
                            onPressed: enviarFormulario,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                              const Color(0xFF00BFA6),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              modoLogin
                                  ? 'Entrar'
                                  : 'Criar conta',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        TextButton(
                          onPressed: alternarModo,
                          child: Text(
                            modoLogin
                                ? 'Ainda não possui uma conta? Cadastre-se'
                                : 'Já possui uma conta? Entrar',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color(0xFF00796B),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration campoDecoracao({
    required String texto,
    required IconData icone,
    Widget? botaoFinal,
  }) {
    return InputDecoration(
      labelText: texto,
      prefixIcon: Icon(icone),
      suffixIcon: botaoFinal,
      filled: true,
      fillColor: const Color(0xFFF4F6F8),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Color(0xFF00BFA6),
          width: 2,
        ),
      ),
    );
  }
}