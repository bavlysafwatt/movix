import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:movix/core/helpers/spacing.dart';
import 'package:movix/core/widgets/app_button.dart';
import 'package:movix/features/discover/domain/entities/discover_filters.dart';
import 'package:movix/features/discover/domain/entities/genre.dart';

class DiscoverFilterSheet extends StatefulWidget {
  const DiscoverFilterSheet({
    super.key,
    required this.genres,
    required this.initialFilters,
    required this.onApply,
  });

  final List<Genre> genres;
  final DiscoverFilters initialFilters;
  final ValueChanged<DiscoverFilters> onApply;

  @override
  State<DiscoverFilterSheet> createState() => _DiscoverFilterSheetState();
}

class _DiscoverFilterSheetState extends State<DiscoverFilterSheet> {
  late DiscoverFilters _filters = widget.initialFilters;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final currentYear = DateTime.now().year;
    final years = List.generate(20, (i) => currentYear - i);

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          responsiveSpacing(context, 20),
          responsiveSpacing(context, 12),
          responsiveSpacing(context, 20),
          responsiveSpacing(context, 20),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(color: colorScheme.outlineVariant, borderRadius: BorderRadius.circular(2)),
                ),
              ),
              verticalSpace(responsiveSpacing(context, 16)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Filters', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                  TextButton(
                    onPressed: () => setState(() => _filters = const DiscoverFilters()),
                    child: const Text('Reset'),
                  ),
                ],
              ),
              verticalSpace(responsiveSpacing(context, 16)),

              _label(context, Icons.category_outlined, 'Genre'),
              verticalSpace(responsiveSpacing(context, 8)),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final genre in widget.genres)
                    ChoiceChip(
                      label: Text(genre.name),
                      selected: _filters.genre?.id == genre.id,
                      onSelected: (selected) => setState(() {
                        _filters = _filters.copyWith(genre: selected ? genre : null, clearGenre: !selected);
                      }),
                    ),
                ],
              ),

              verticalSpace(responsiveSpacing(context, 20)),
              _label(context, Icons.calendar_today_outlined, 'Release Year'),
              verticalSpace(responsiveSpacing(context, 8)),
              SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: years.length,
                  separatorBuilder: (_, __) => horizontalSpace(8),
                  itemBuilder: (context, index) {
                    final year = years[index];
                    final selected = _filters.year == year;
                    return ChoiceChip(
                      label: Text('$year'),
                      selected: selected,
                      onSelected: (isSelected) => setState(() {
                        _filters = _filters.copyWith(year: isSelected ? year : null, clearYear: !isSelected);
                      }),
                    );
                  },
                ),
              ),

              verticalSpace(responsiveSpacing(context, 20)),
              _label(context, FontAwesomeIcons.star, 'Minimum Rating: ${_filters.minRating?.toStringAsFixed(1) ?? 'Any'}'),
              Slider(
                value: _filters.minRating ?? 0,
                min: 0,
                max: 9,
                divisions: 18,
                label: _filters.minRating?.toStringAsFixed(1) ?? 'Any',
                onChanged: (value) => setState(() {
                  _filters = value == 0
                      ? _filters.copyWith(clearMinRating: true)
                      : _filters.copyWith(minRating: value);
                }),
              ),

              verticalSpace(responsiveSpacing(context, 12)),
              _label(context, Icons.sort_rounded, 'Sort By'),
              verticalSpace(responsiveSpacing(context, 8)),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final sort in DiscoverSort.values)
                    ChoiceChip(
                      label: Text(sort.label),
                      selected: _filters.sort == sort,
                      onSelected: (_) => setState(() => _filters = _filters.copyWith(sort: sort)),
                    ),
                ],
              ),

              verticalSpace(responsiveSpacing(context, 24)),
              AppButton(
                text: 'Apply Filters',
                onPressed: () {
                  widget.onApply(_filters);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(BuildContext context, IconData icon, String text) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(icon, size: 16, color: colorScheme.onSurfaceVariant),
        horizontalSpace(6),
        Text(text, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: colorScheme.onSurfaceVariant)),
      ],
    );
  }
}