import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:asuka/asuka.dart';
import 'package:camera/camera.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:safe_lopes_family/modules/registration/registration_cubit.dart';
import 'package:safe_lopes_family/modules/registration/widgets/camera_page.dart';
import 'package:safe_lopes_family/src/widgets/custom_photo_marker/custom_photo_marker.dart';
import 'package:safe_lopes_family/src/widgets/safe_family_text_form_field/safe_family_text_form_field.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  bool visiblePassword = false;
  final RegistrationCubit registrationCubit = Modular.get();
  late List<CameraDescription> _cameras;
  late CameraController controller;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController repeatPasswordController =
      TextEditingController();
  final formKey = GlobalKey<FormState>();
  final phoneMask = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );
  XFile? picture;
  final widgetToImageController = WidgetsToImageController();

  @override
  void initState() {
    super.initState();
    _getAvailableCameras();
  }

  void _initializeCameraController() {
    controller = CameraController(_cameras[1], ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
  }

  Future _getAvailableCameras() async {
    _cameras = await availableCameras();
    _initializeCameraController();
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'Cadastro',
              style: TextStyle(fontSize: 22, fontFamily: 'Nunito'),
            ),
            SizedBox(
              height: 35,
              width: 35,
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          if (picture != null)
            WidgetsToImage(
              controller: widgetToImageController,
              child: CustomPhotoMarker(picture: picture!),
            ),
          Container(
            color: Colors.white,
            height: double.infinity,
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left: 22, top: 22, right: 22),
                  child: BlocConsumer(
                    bloc: registrationCubit,
                    listener: (context, state) {
                      if (state.runtimeType == RegistrationErrorState) {
                        var errorState = state as RegistrationErrorState;
                        var snackBar =
                            SnackBar(content: Text(errorState.message));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                      if (state.runtimeType == RegistrationSuccessState) {
                        Modular.to.popUntil((route) => route.isFirst);
                      }
                    },
                    builder: (context, state) {
                      return Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CameraPage(
                                      controller: controller,
                                      switchCameras: () {
                                        setState(() {
                                          final lensDirection = controller
                                              .description.lensDirection;
                                          CameraDescription newDescription;
                                          if (lensDirection ==
                                              CameraLensDirection.front) {
                                            newDescription = _cameras
                                                .firstWhere((description) =>
                                                    description.lensDirection ==
                                                    CameraLensDirection.back);
                                          } else {
                                            newDescription = _cameras
                                                .firstWhere((description) =>
                                                    description.lensDirection ==
                                                    CameraLensDirection.front);
                                          }
                                          controller = CameraController(
                                              newDescription,
                                              ResolutionPreset.max);
                                        });
                                      },
                                      takePicture: (file) {
                                        setState(() {
                                          picture = file;
                                        });
                                      },
                                    ),
                                  ),
                                );
                              },
                              child: Stack(
                                children: [
                                  SizedBox(
                                    height: 140,
                                    width: 140,
                                    child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(200.0),
                                      child: FittedBox(
                                        fit: BoxFit.fitWidth,
                                        clipBehavior: Clip.antiAlias,
                                        child: (picture != null)
                                            ? Image.file(
                                                File(
                                                  picture!.path,
                                                ),
                                              )
                                            : const Icon(
                                                Icons.account_circle_outlined,
                                                color: Colors.grey,
                                                weight: .1,
                                              ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 6,
                                    right: 6,
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: const Icon(
                                        Icons.camera_alt_outlined,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 22,
                            ),
                            SafeFamilyTextFormField(
                              controller: nameController,
                              keyboardType: TextInputType.text,
                              labelText: 'Nome completo',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Campo vazio';
                                }
                                if (value.length < 3) {
                                  return 'Nome inválido';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            SafeFamilyTextFormField(
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              obscureText: visiblePassword,
                              labelText: 'E-mail',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Campo vazio';
                                }
                                if (!EmailValidator.validate(value)) {
                                  return 'E-mail inválido';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            SafeFamilyTextFormField(
                              controller: phoneController,
                              keyboardType: TextInputType.phone,
                              labelText: 'Celular',
                              inputFormatters: [phoneMask],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Campo vazio';
                                }
                                if (value.length < 15) {
                                  return 'Celular inválido';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            SafeFamilyTextFormField(
                              controller: passwordController,
                              keyboardType: TextInputType.text,
                              obscureText: true,
                              maxLength: 8,
                              labelText: 'Senha',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Campo vazio';
                                }
                                if (value.length < 8) {
                                  return 'Mínimo 8 dígitos';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            SafeFamilyTextFormField(
                              controller: repeatPasswordController,
                              keyboardType: TextInputType.text,
                              maxLength: 8,
                              obscureText: true,
                              labelText: 'Repita a senha',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Campo vazio';
                                }
                                if (value.length < 8) {
                                  return 'Mínimo 8 dígitos';
                                }
                                if (passwordController.text !=
                                    repeatPasswordController.text) {
                                  return 'Repita a senha corretamente';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      if (formKey.currentState!.validate()) {
                                        if (picture == null) {
                                          Asuka.showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Foto de perfil obrigatória',
                                              ),
                                            ),
                                          );
                                        } else {
                                          final widgetImage =
                                              await widgetToXFile(
                                            CustomPhotoMarker(
                                                picture: picture!),
                                          );
                                          registrationCubit.userEntity =
                                              registrationCubit.userEntity
                                                  .copyWith(
                                            name: nameController.text,
                                            email: emailController.text,
                                            phone: phoneController.text,
                                            photoUrl: '',
                                          );
                                          await registrationCubit.signUp(
                                              passwordController.text,
                                              picture!,
                                              widgetImage);
                                        }
                                      }
                                    },
                                    child: state.runtimeType ==
                                            RegistrationLoadingState
                                        ? const CircularProgressIndicator(
                                            color: Colors.white,
                                          )
                                        : const Text('Cadastrar'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<XFile> widgetToXFile(Widget widget) async {
    Uint8List? bytes;

    bytes = await widgetToImageController.capture();
    final tempDir = await getTemporaryDirectory();
    final filePath = '${tempDir.path}/pin.png';
    final file = File(filePath);
    await file.writeAsBytes(bytes!);
    return XFile(filePath);
  }
}
