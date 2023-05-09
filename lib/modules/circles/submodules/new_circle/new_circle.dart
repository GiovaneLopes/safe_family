import 'package:asuka/asuka.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:safe_lopes_family/modules/circles/submodules/new_circle/new_circle_cubit.dart';

class NewCircle extends StatelessWidget {
  const NewCircle({super.key});

  @override
  Widget build(BuildContext context) {
    final NewCircleCubit newCircleCubit = Modular.get();
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
              'Novo círculo',
              style: TextStyle(fontSize: 22, fontFamily: 'Nunito'),
            ),
            SizedBox(width: 45),
          ],
        ),
      ),
      body: BlocConsumer(
        bloc: newCircleCubit,
        listener: (context, state) {
          if (state.runtimeType == NewCircleSuccessState) {
            var successState = state as NewCircleSuccessState;
            Asuka.showDialog(builder: (context) {
              return Dialog(
                elevation: 0,
                backgroundColor: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                            offset: const Offset(2, 2),
                            blurRadius: 5,
                            spreadRadius: 4,
                            color: Colors.black.withOpacity(.05)),
                      ]),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: const [
                          Expanded(
                            child: Text(
                              'Círculo criado',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                  fontFamily: 'Nunito'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 22,
                      ),
                      const Text(
                        'Seu código é:',
                        style: TextStyle(fontSize: 18, fontFamily: 'Nunito'),
                      ),
                      Text(
                        successState.code,
                        style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Nunito'),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Ok'),
                      ),
                    ],
                  ),
                ),
              );
            });
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
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
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      width: 22,
                    ),
                    const Text(
                      'Crie um novo círculo',
                      style: TextStyle(
                        fontSize: 22,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 22,
                ),
                const Text(
                  'Crie um novo círculo e envie o código gerado para os membros da sua família',
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 16, fontFamily: 'Nunito'),
                ),
                const SizedBox(
                  height: 22,
                ),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async =>
                            await newCircleCubit.saveNewCircle(),
                        child: const Text('Gerar código'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
