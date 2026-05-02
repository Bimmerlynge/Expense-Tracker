import 'package:expense_tracker/app/config/theme/app_colors.dart';
import 'package:expense_tracker/app/shared/widgets/header_title.dart';
import 'package:expense_tracker/features/categories/presentation/create_category/create_category_popup.dart';
import 'package:flutter/material.dart';

class CategoryListTabHeader extends StatelessWidget {
  const CategoryListTabHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: _title()),
          SizedBox(width: 50),
          _createButton(context)
        ],
      ),
    );
  }

  Widget _title() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeaderTitle(title: "Kategorier i hustanden"),
        SizedBox(height: 4),
        FractionallySizedBox(
            widthFactor: 0.8,
            child: Text(
              'Vælg hvilken kategori appen bruger som standard. \nÆndrer ikonet for en given kategori.',
              style: TextStyle(color: AppColors.white, fontSize: 11),
              softWrap: true,
            ))
      ],
    );
  }

  Widget _createButton(BuildContext context) {
    return Container(
      height: 75,
      width: 75,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [
            AppColors.secondary.withOpacity(0.95),
            AppColors.secondary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
        border: Border.all(
          color: Colors.white.withOpacity(0.15),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () => _showCreateCategoryPopup(context),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.15),
                Colors.transparent,
              ],
              begin: Alignment.topLeft,
              end: Alignment.center,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add, color: AppColors.whiter),
              SizedBox(height: 2),
              Text('Opret', style: TextStyle(color: AppColors.whiter, fontSize: 12)),
              Text('kategori', style: TextStyle(color: AppColors.whiter, fontSize: 12))
            ],
          ),
        ),
      ),
    );
  }

  void _showCreateCategoryPopup(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) {
        return CreateCategoryPopup();
      },
    );
  }
}
