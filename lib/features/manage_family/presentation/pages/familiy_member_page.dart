import 'dart:developer';

import 'package:aayojan/core/theme/custom_colors.dart';
import 'package:aayojan/core/theme/custom_typo.dart';
import 'package:aayojan/core/widgets/custom_button.dart';
import 'package:aayojan/core/widgets/custom_button2.dart';
import 'package:aayojan/features/manage_family/presentation/bloc/famil_state.dart';
import 'package:aayojan/features/manage_family/presentation/bloc/family_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/network/endpoints.dart';
import '../widgets/family_card.dart';
import 'manage_family_member_page.dart';

class FamiliyMemberPage extends StatefulWidget {
  static const String routeName = '/family-member';
  const FamiliyMemberPage({super.key});

  @override
  State<FamiliyMemberPage> createState() => _FamiliyMemberPageState();
}

class _FamiliyMemberPageState extends State<FamiliyMemberPage> {
  Map<int, String> relationMap = {};

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<FamilyCubit>()..getFamilies(),
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              'Family Members',
              style: CustomTypography.titleMedium,
            ),
            centerTitle: true,
          ),
          body: BlocConsumer<FamilyCubit, FamilyState>(
            listener: (context, state) {
              if (state is FamilyLoaded) {
                for (var item in state.relations.data ?? []) {
                  relationMap[item.id!] = item.name!;
                }
              }
            },
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      CustomButtonOut(
                        onPressed: () async {
                          bool isExistFamilyMember =
                              await const FlutterSecureStorage()
                                  .containsKey(key: 'noFamilyId');
                          log(isExistFamilyMember.toString());
                          if (isExistFamilyMember) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Please add family id first",
                                  style: CustomTypography.bodyMedium.copyWith(
                                      color: CustomColors.contentPrimary),
                                ),
                                backgroundColor: CustomColors.bgLight,
                              ),
                            );
                            return;
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) {
                              return const ManageFamilyMember(
                                isEdit: false,
                              );
                            }),
                          ).then((value) {
                            if (value == true) {
                              context.read<FamilyCubit>().getFamilies();
                            }
                          });
                        },
                        content: Text(
                          "+ Add Family Member",
                          style: CustomTypography.bodyMedium.copyWith(
                            color: CustomColors.bgLight,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        isLoading: false,
                        borderColor: CustomColors.bgLight,
                        backgroundColor: CustomColors.primary,
                        height: 54,
                        width: MediaQuery.sizeOf(context).width * .8,
                      ),
                      const SizedBox(height: 16),
                      // list of family members
                      if (state is FamilyLoading)
                        SizedBox(
                          height: MediaQuery.sizeOf(context).height * 0.7,
                          child: const Center(
                            child: SizedBox(
                              height: 50,
                              width: 50,
                              child: CircularProgressIndicator(
                                color: CustomColors.bgLight,
                              ),
                            ),
                          ),
                        )
                      else if (state is FamilyFailure)
                        SizedBox(
                          height: MediaQuery.sizeOf(context).height * 0.7,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  state.message,
                                  style: CustomTypography.bodyLarge
                                      .copyWith(color: CustomColors.error),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                CustomButton(
                                  onPressed: () {
                                    context.read<FamilyCubit>().getFamilies();
                                  },
                                  text: 'Retry',
                                  isLoading: false,
                                  height: 40,
                                  width: 128,
                                ),
                              ],
                            ),
                          ),
                        )
                      else if (state is FamilyLoaded)
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.family.familyData?[0].members
                                  ?.memberData?.length ??
                              0,
                          itemBuilder: (context, index) {
                            final family = state.family.familyData?[0].members
                                ?.memberData?[index];
                            return FamilyCard(
                              onEdit: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return ManageFamilyMember(
                                    isEdit: true,
                                    first_name: family?.firstName ?? "",
                                    last_name: family?.lastName ?? "",
                                    age: family?.age ?? 0,
                                    phone: family?.phone ?? "",
                                    relation_id: family?.relationId ?? -1,
                                    category_id:
                                        family?.relationCategoryId ?? 0,
                                    id: family?.id ?? 0,
                                    city: family?.cityId ?? -1,
                                    gender: family?.gender ?? "-1",
                                    state: family?.stateId ?? -1,
                                    address: family?.address ?? "",
                                    altPhone: family?.alternatePhone ?? "",
                                    image: family?.profile ?? "",
                                    town: family?.town ?? "",
                                  );
                                })).then((value) {
                                  if (value == true) {
                                    context.read<FamilyCubit>().getFamilies();
                                  }
                                });
                                },
                                name: "${(family?.firstName ?? "").isNotEmpty ? "${family?.firstName![0].toUpperCase()}${family?.firstName!.substring(1).toLowerCase()}" : ""} ${(family?.lastName ?? "").isNotEmpty ? "${family?.lastName![0].toUpperCase()}${family?.lastName!.substring(1).toLowerCase()}" : ""}".trim(),
                              relationName:
                                  relationMap[family?.relationId ?? 0] ?? "",
                              imageUrl: family?.profile ?? '',
                              onDelete: () {
                                // log(familyId.toString());
                                // context
                                //     .read<FamilyCubit>()
                                //     .deleteFamily(familyId.toString());

                                showDialog(
                                  context: context,
                                  builder: (dialogContext) {
                                    return BlocProvider.value(
                                      value: context.read<FamilyCubit>(),
                                      child: AlertDialog(
                                        title:
                                            const Text("Delete Family Member"),
                                        content: const Text(
                                            "Are you sure you want to delete this family member?"),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(dialogContext);
                                            },
                                            child: const Text("No"),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              log('here');
                                              context
                                                  .read<FamilyCubit>()
                                                  .deleteFamily(
                                                      (family?.id).toString());
                                              Navigator.pop(dialogContext);
                                            },
                                            child: const Text("Yes"),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          },
                        ),
                    ],
                  ),
                ),
              );
            },
          )),
    );
  }
}
