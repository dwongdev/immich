import { ApiProperty } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import {
  IsDateString,
  IsInt,
  IsLatitude,
  IsLongitude,
  IsNotEmpty,
  IsPositive,
  IsString,
  Max,
  Min,
  ValidateIf,
} from 'class-validator';
import { BulkIdsDto } from 'src/dtos/asset-ids.response.dto';
import { AssetType, AssetVisibility } from 'src/enum';
import { AssetStats } from 'src/repositories/asset.repository';
import { Optional, ValidateBoolean, ValidateEnum, ValidateUUID } from 'src/validation';

export class DeviceIdDto {
  @IsNotEmpty()
  @IsString()
  deviceId!: string;
}

const hasGPS = (o: { latitude: undefined; longitude: undefined }) =>
  o.latitude !== undefined || o.longitude !== undefined;
const ValidateGPS = () => ValidateIf(hasGPS);

export class UpdateAssetBase {
  @ValidateBoolean({ optional: true })
  isFavorite?: boolean;

  @ValidateEnum({ enum: AssetVisibility, name: 'AssetVisibility', optional: true })
  visibility?: AssetVisibility;

  @Optional()
  @IsDateString()
  dateTimeOriginal?: string;

  @ValidateGPS()
  @IsLatitude()
  @IsNotEmpty()
  latitude?: number;

  @ValidateGPS()
  @IsLongitude()
  @IsNotEmpty()
  longitude?: number;

  @Optional()
  @IsInt()
  @Max(5)
  @Min(-1)
  rating?: number;

  @Optional()
  @IsString()
  description?: string;
}

export class AssetBulkUpdateDto extends UpdateAssetBase {
  @ValidateUUID({ each: true })
  ids!: string[];

  @Optional()
  duplicateId?: string | null;
}

export class UpdateAssetDto extends UpdateAssetBase {
  @ValidateUUID({ optional: true, nullable: true })
  livePhotoVideoId?: string | null;
}

export class RandomAssetsDto {
  @Optional()
  @IsInt()
  @IsPositive()
  @Type(() => Number)
  count?: number;
}

export class AssetBulkDeleteDto extends BulkIdsDto {
  @ValidateBoolean({ optional: true })
  force?: boolean;
}

export class AssetIdsDto {
  @ValidateUUID({ each: true })
  assetIds!: string[];
}

export enum AssetJobName {
  REFRESH_FACES = 'refresh-faces',
  REFRESH_METADATA = 'refresh-metadata',
  REGENERATE_THUMBNAIL = 'regenerate-thumbnail',
  TRANSCODE_VIDEO = 'transcode-video',
}

export class AssetJobsDto extends AssetIdsDto {
  @ValidateEnum({ enum: AssetJobName, name: 'AssetJobName' })
  name!: AssetJobName;
}

export class AssetStatsDto {
  @ValidateEnum({ enum: AssetVisibility, name: 'AssetVisibility', optional: true })
  visibility?: AssetVisibility;

  @ValidateBoolean({ optional: true })
  isFavorite?: boolean;

  @ValidateBoolean({ optional: true })
  isTrashed?: boolean;
}

export class AssetStatsResponseDto {
  @ApiProperty({ type: 'integer' })
  images!: number;

  @ApiProperty({ type: 'integer' })
  videos!: number;

  @ApiProperty({ type: 'integer' })
  total!: number;
}

export const mapStats = (stats: AssetStats): AssetStatsResponseDto => {
  return {
    images: stats[AssetType.Image],
    videos: stats[AssetType.Video],
    total: Object.values(stats).reduce((total, value) => total + value, 0),
  };
};
