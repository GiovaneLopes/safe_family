import 'package:asuka/asuka.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:safe_lopes_family/modules/circles/circles_cubit.dart';
import 'package:safe_lopes_family/src/widgets/safe_family_text_form_field/safe_family_text_form_field.dart';

class CirclesPage extends StatefulWidget {
  const CirclesPage({super.key});

  @override
  State<CirclesPage> createState() => _CirclesPageState();
}

class _CirclesPageState extends State<CirclesPage> {
  final CirclesCubit circlesCubit = Modular.get();
  final formKey = GlobalKey<FormState>();
  final TextEditingController codeController = TextEditingController();
  bool copiedCode = false;

  @override
  void initState() {
    super.initState();
    circlesCubit.getUserCircles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Modular.to.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            SizedBox(),
            Text(
              'Circulos',
              style: TextStyle(fontSize: 22, fontFamily: 'Nunito'),
            ),
            SizedBox(width: 45),
          ],
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 22, top: 22, right: 22),
          child: BlocConsumer(
            bloc: circlesCubit,
            listener: (context, state) {
              if (state.runtimeType == CirclesErrorState) {
                var errorState = state as CirclesErrorState;
                var snackBar = SnackBar(content: Text(errorState.message));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
            builder: (context, state) {
              if (state.runtimeType == CirclesLoadingState) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.blue),
                );
              }
              if (state.runtimeType == CirclesErrorState) {
                return Column(
                  children: [
                    IconButton(
                      onPressed: () => circlesCubit.getUserCircles(),
                      icon: const Icon(
                        Icons.update,
                      ),
                    ),
                  ],
                );
              }
              final successState = state as CirclesSuccessState;
              if (successState.circle.users.isNotEmpty) {
                return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: const [
                              Icon(
                                Icons.key,
                                color: Colors.blue,
                                size: 28,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                'Código de convite',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Nunito',
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                successState.circle.code,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontFamily: 'Nunito',
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.share,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      await Clipboard.setData(ClipboardData(
                                          text: successState.circle.code));
                                      Asuka.showSnackBar(const SnackBar(
                                          content: Text(
                                              'Código copiado com sucesso')));
                                      setState(() {
                                        copiedCode = true;
                                      });
                                    },
                                    icon: Icon(
                                      Icons.copy,
                                      color: copiedCode
                                          ? Colors.blue
                                          : Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      const Divider(),
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        children: const [
                          Icon(
                            Icons.person,
                            color: Colors.blue,
                            size: 28,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            'Pessoas',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Nunito',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Column(
                        children: successState.circle.users.map((user) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Colors.blue,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(200.0),
                                    child: FittedBox(
                                      fit: BoxFit.fitWidth,
                                      clipBehavior: Clip.antiAlias,
                                      child: CachedNetworkImage(
                                        imageUrl: user.photoUrl!,
                                        progressIndicatorBuilder:
                                            (context, url, progress) =>
                                                const Padding(
                                          padding: EdgeInsets.all(12),
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        ),
                                        errorWidget:
                                            (context, exception, stack) =>
                                                const Icon(
                                          Icons.person,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      user.name,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Nunito',
                                      ),
                                    ),
                                    const Text(
                                      'Localização: Av Assis Ribeiro',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'Nunito',
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const Text(
                                      '12:46',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'Nunito',
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ]);
              } else {
                return Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.blue,
                          ),
                          child: const Icon(
                            Icons.key,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          width: 22,
                        ),
                        const Expanded(
                          child: Text(
                            'Entre em um círculo já existente',
                            style: TextStyle(
                              fontSize: 22,
                              fontFamily: 'Nunito',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 22,
                    ),
                    Row(
                      children: const [
                        Expanded(
                          child: Text(
                            'Insira o código do círculo que deseja fazer parte',
                            textAlign: TextAlign.start,
                            style:
                                TextStyle(fontSize: 16, fontFamily: 'Nunito'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 22,
                    ),
                    Form(
                      key: formKey,
                      child: SafeFamilyTextFormField(
                        controller: codeController,
                        keyboardType: TextInputType.emailAddress,
                        labelText: 'Código',
                        maxLength: 6,
                        prefixIcon: const Icon(
                          Icons.key,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Campo vazio';
                          }
                          if (value.length < 6) {
                            return 'Código deve ter 6 dígitos';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 22,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                circlesCubit
                                    .setInvitationCode(codeController.text);
                              }
                            },
                            child: state.runtimeType == CirclesLoadingState
                                ? const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text(
                                    'Entrar',
                                    style: TextStyle(
                                        fontSize: 16, fontFamily: 'Nunito'),
                                  ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 22,
                    ),
                    const Text(
                      'OU',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Nunito',
                      ),
                    ),
                    const SizedBox(
                      height: 22,
                    ),
                    InkWell(
                      onTap: () => Modular.to.pushNamed('/circles/new-circle'),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              'Criar novo círculo',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'Nunito',
                                  color: Colors.blue),
                            ),
                            Icon(
                              Icons.add,
                              color: Colors.blue,
                            ),
                          ]),
                    )
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
