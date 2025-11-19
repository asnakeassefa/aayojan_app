import 'package:flutter/material.dart';

import '../../../../core/theme/custom_colors.dart';

class InvitationCard extends StatelessWidget {
  final String status;
  final String title;
  final String date;
  final String imagePath;
  final Function? onPressed;
  const InvitationCard({
    super.key,
    this.onPressed,
    required this.status,
    required this.title,
    required this.date,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        if (onPressed != null) onPressed!();
      },
      icon: Container(
        padding: const EdgeInsets.only(left: 6),
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          // color: status == "success" ? AppColors.secondaryColor :status == 'on progress'? Colors.orange: Colors.red,
          color: CustomColors.primary,
        ),
        child: Container(
          width: double.infinity,
          height: 70,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10)),
              color: CustomColors.bgTeritary,
              boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 1)]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 54,
                width: 54,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: CustomColors.primary,
                    borderRadius: BorderRadius.circular(16)),
                child: Image.asset(
                  imagePath,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width * .55,
                    child: Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width * 0.4,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Date: $date',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
